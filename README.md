# NixOS Configuration

My personal NixOS configuration, first time doing that!

I use [Dux](https://duxlabs.dev/docs/dms/nixos-flake) with Hyprland!


## Dux Settings

The `programs.dank-material-shell.settings` block accepts Dux settings as Nix attributes. To find the settings for a specific option:

1. Save the current settings:
    ```bash
    dms ipc call settings dump > before-dms-settings.json
    ```

2. Change the option in the Dux settings interface, then save the updated settings:
   ```bash
   dms ipc call settings dump > after-dms-settings.json
   ```

3. Compare the two files:
   ```bash
   diff -u before-dms-settings.json after-dms-settings.json
   ```

Translate the changed JSON values into Nix syntax and add them to `programs.dank-material-shell.settings` in `modules/user/dux/default.nix`.

For exemple,
```json
{
  "exampleEnabled": true,
  "exampleStyle": "round",
  "exampleSize": 42,
  "exampleItems": ["first", "second"]
}
```
is equivalent to:
```nix
programs.dank-material-shell.settings = {
  exampleEnabled = true;
  exampleStyle = "round";
  exampleSize = 42;
  exampleItems = [ "first" "second" ];
};
```


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
