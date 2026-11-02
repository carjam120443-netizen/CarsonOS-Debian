# CarsonOS Debian

A customized Debian Testing live distribution with XFCE, Calamares, and a practical hybrid-update philosophy.

> **Development status:** early bring-up. The first milestone is a bootable live ISO; installer branding, installed-system polish, and VM testing remain follow-up work.

## Project goals

- Track Debian **Testing** (the moving suite), not a permanently pinned release codename.
- Provide an XFCE desktop with LightDM.
- Ship a live session and the Calamares graphical installer.
- Produce an amd64 hybrid ISO intended for UEFI and legacy BIOS boot.
- Keep Debian APT as the package-management foundation.
- Prefer sensible defaults and tested updates while retaining access to newer Testing packages.

"Hybrid" describes the project's update philosophy. Debian Testing is a rolling development suite and does **not** receive the same security-team support or guarantees as Debian Stable. Back up important data and test upgrades before using this system as a daily driver.

## Build

The supported first build path is Debian or Ubuntu with root/sudo access, or the GitHub Actions workflow.

### Local build

Install the build dependencies:

```sh
sudo apt-get update
sudo apt-get install -y live-build debootstrap squashfs-tools xorriso \
  grub-pc-bin grub-efi-amd64-bin mtools dosfstools
```

Then run:

```sh
sudo ./scripts/build-iso.sh
```

The resulting image is written to `build/CarsonOS-Debian-amd64.iso`.

### GitHub Actions

Push to `main` or manually run **Build CarsonOS Debian ISO** from the Actions tab. The workflow uploads the ISO as a build artifact.

## Repository layout

- `auto/config` — live-build configuration.
- `config/package-lists/` — packages installed into the live image.
- `config/includes.chroot/` — files copied into the live filesystem.
- `scripts/build-iso.sh` — reproducible local build entry point.
- `.github/workflows/build-iso.yml` — CI build and artifact upload.

## Current build choices

| Area | Selection |
|---|---|
| Base suite | Debian Testing |
| Architecture | amd64 |
| Desktop | XFCE |
| Display manager | LightDM |
| Installer | Calamares + Debian's packaged settings as an initial working baseline |
| Init | systemd |
| Boot | GRUB EFI + BIOS, ISO hybrid |
| Package manager | APT |
| Default filesystem target | ext4 (installer choice, not a live-image filesystem constraint) |

The Debian Calamares settings package is used as a functional starting point. Rebranding its installer presentation and reviewing its install-time APT source configuration are explicit follow-up tasks; the initial ISO must not be mistaken for a finished CarsonOS-branded installer.

## Safety and testing

- Test the ISO in a virtual machine before trying it on physical hardware.
- Do not select or format a physical disk unless you deliberately intend to install there.
- Verify the downloaded ISO checksum before booting it.
- Debian Testing can temporarily have broken or transitional packages. A successful ISO build does not prove every installer path works.

## License

Project-specific scripts and configuration are provided under the MIT License unless a file states otherwise. Debian packages and their assets retain their respective upstream licenses.
