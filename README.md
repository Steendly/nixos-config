# NixOS Configuration

My personal NixOS configuration, first time doing that!

I plan to use [Dux](https://duxlabs.dev/docs/dms/nixos-flake).

This README will be updated maybe one day...


## Deploy to a VM

This workflow uses the [GNOME Boxes rewrite](https://nightly.gnomeboxes.org/), which provides SSH port forwarding to access the VM from the host.

Create a VM and install NixOS. Inside the VM, edit `/etc/nixos/configuration.nix` and add these options inside the existing configuration block:

```nix
# Enable OpenSSH
services.openssh.enable = true;

# Allow the deployment user to run sudo
users.users.username.extraGroups = [ "wheel" ];
```

Replace `username` with your VM username. The account must have a password for SSH password authentication and sudo, or an authorized SSH key for SSH authentication.

Apply this initial configuration from a terminal inside the VM:

```bash
sudo nixos-rebuild switch
```

In Boxes, open the VM's properties and enable the SSH access in Network options. Note the host port assigned to SSH: the examples below use `2222`. Replace it with the port shown in your settings.

From the host, check the connection:

```bash
ssh username@localhost -p 2222
```

Keep SSH enabled and your user configured in the configuration you deploy afterward.

Run the following deployment commands from the local directory containing `flake.nix`. Replace `username` with your VM username and `tester` with the configuration name :


### Build locally and deploy to the VM

The local machine must be able to build for the target architecture.

```bash
NIX_SSHOPTS="-p 2222" nix run nixpkgs#nixos-rebuild-ng -- switch \
  --flake .#tester \
  --target-host username@localhost \
  --sudo \
  --ask-sudo-password
```


### Build and deploy on the VM

```bash
NIX_SSHOPTS="-p 2222" nix run nixpkgs#nixos-rebuild-ng -- switch \
  --flake .#tester \
  --build-host username@localhost \
  --target-host username@localhost \
  --sudo \
  --ask-sudo-password
```

- `NIX_SSHOPTS="-p 2222"` sets the SSH port for this command only, without modifying your SSH configuration.
- `--sudo` uses sudo on the remote machine to activate the new system configuration with root privileges.
- `--ask-sudo-password` prompts for the remote user's sudo password. Omit it if that user has passwordless sudo.
