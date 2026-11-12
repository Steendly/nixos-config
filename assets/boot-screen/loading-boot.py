import argparse
import json
import math
from pathlib import Path

from PIL import Image, ImageDraw

SIZE = 56
SCALE = 4
DEFAULT_COLOR = "#f3edf7"
CIRCLE_COLOR = "#cac4d0"
INDICATOR_SIZE = 44
FRAMES_PER_CYCLE = 60
DATA_FILE = Path(__file__).with_name("material-shapes.json")
CURVE_TOLERANCE = 0.00005


def load_morphs(path=DATA_FILE):
    data = json.loads(Path(path).read_text())
    if data["format"] != 1:
        raise ValueError("Unsupported material-shapes.json format")
    morphs = data["morphs"]
    for morph in morphs:
        if not morph["start"] or len(morph["start"]) != len(morph["end"]):
            raise ValueError("Morph endpoints must have matching cubic counts")
        for cubic in morph["start"] + morph["end"]:
            if len(cubic) != 8 or not all(math.isfinite(v) for v in cubic):
                raise ValueError("Invalid cubic coordinates")
    return morphs


def flatten(cubic, points):
    """Adaptive de Casteljau subdivision, bounded by control-point distances."""
    a, b, c, d = [complex(*cubic[i:i + 2]) for i in range(0, 8, 2)]

    def append_curve(a, b, c, d):
        chord = d - a
        if abs(chord) < 1e-12:
            flatness = max(abs(b - a), abs(c - a))
        else:
            # Distance to the chord segment, also handling collinear overshoot.
            def distance(p):
                t = max(0, min(1, ((p-a).conjugate()*chord).real / abs(chord)**2))
                return abs(p - (a + t*chord))
            flatness = max(distance(b), distance(c))
        if flatness <= CURVE_TOLERANCE:
            points.append(d)
            return
        ab, bc, cd = (a+b)/2, (b+c)/2, (c+d)/2
        abc, bcd = (ab+bc)/2, (bc+cd)/2
        mid = (abc+bcd)/2
        append_curve(a, ab, abc, mid)
        append_curve(mid, bcd, cd, d)

    if not points:
        points.append(a)
    append_curve(a, b, c, d)


def render_morph(morph, progress, rotation=0, primary_color=DEFAULT_COLOR):
    points = []
    # Morph.asCubics uses this same linear interpolation of matched controls.
    for start, end in zip(morph["start"], morph["end"]):
        flatten([a + (b-a)*progress for a, b in zip(start, end)], points)

    # Center the visible path, as LoadingIndicator.processPath does.
    center = complex(
        (min(p.real for p in points) + max(p.real for p in points))/2,
        (min(p.imag for p in points) + max(p.imag for p in points))/2,
    )
    transform = INDICATOR_SIZE * complex(math.cos(rotation), math.sin(rotation))
    pixels = [(p-center)*transform + complex(SIZE/2, SIZE/2) for p in points]
    canvas_size = SIZE * SCALE
    image = Image.new("RGBA", (canvas_size, canvas_size))
    draw = ImageDraw.Draw(image)
    draw.ellipse((0, 0, canvas_size - 1, canvas_size - 1), fill=CIRCLE_COLOR)
    draw.polygon(
        [(p.real*SCALE, p.imag*SCALE) for p in pixels], fill=primary_color
    )
    return image.resize((SIZE, SIZE), Image.Resampling.LANCZOS)


def render_frame(index, morphs, primary_color=DEFAULT_COLOR):
    phase = len(morphs) * index / FRAMES_PER_CYCLE
    shape = math.floor(phase) % len(morphs)
    fraction = phase - math.floor(phase)
    # Preserve the previous boot timing/easing. Android's spring and extra
    # quarter-turns are intentionally not claimed to be reproduced here.
    progress = fraction*fraction*(3-2*fraction)
    rotation = index / FRAMES_PER_CYCLE * math.tau
    return render_morph(morphs[shape], progress, rotation, primary_color)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path)
    parser.add_argument("--geometry", type=Path, default=DATA_FILE)
    parser.add_argument("--primary-color", default=DEFAULT_COLOR)
    args = parser.parse_args()
    morphs = load_morphs(args.geometry)
    args.output.mkdir(parents=True, exist_ok=True)
    for index in range(FRAMES_PER_CYCLE):
        frame = render_frame(index, morphs, args.primary_color)
        frame.save(args.output / f"throbber-{index+1:04d}.png")


if __name__ == "__main__":
    main()
