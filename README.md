# MATLAB R2024a Installation Guide for Ubuntu 24.04

This guide provides a detailed, step-by-step process for installing MATLAB R2024a on Ubuntu 24.04. Due to library compatibility issues (specifically `libstdc++.so.6`), a silent installation using an input file is the most reliable method.

## Prerequisites

1.  **MATLAB R2024a ISO**: Ensure you have the `R2024a_Linux.iso` file.
2.  **Crack Files**: This repository includes the necessary `license.lic` and `libmwlmgrimpl.so` for activation.
3.  **Root Access**: You will need `sudo` privileges.

## Installation Steps

### 1. Mount the ISO Image
Create a mount point and mount the ISO file to access the installer:
```bash
sudo mkdir -p /mnt/matlab
sudo mount -o loop /path/to/R2024a_Linux.iso /mnt/matlab
```

### 2. Configure the Installer
The `installer_input.txt` file in this repository is pre-configured for a silent installation. 
- It sets the destination to `/usr/local/MATLAB/R2024a`.
- It points to the `license.lic` included in this folder.
- It selects the core `MATLAB` product for installation.

If you need to change the installation path or add more products, edit `installer_input.txt` before proceeding.

### 3. Run the Silent Installation
Execute the installer using the input file. The `-E` flag preserves environment variables:
```bash
cd /mnt/matlab
sudo -E ./install -inputFile /path/to/this/repo/installer_input.txt
```
*Note: The installation may take several minutes. If it finishes instantly without errors, check if the files were actually created in `/usr/local/MATLAB/R2024a`.*

### 4. Apply the Activation Patch
Replace the original license manager implementation with the patched version:
```bash
cd /usr/local/MATLAB/R2024a/bin/glnxa64/matlab_startup_plugins/lmgrimpl
sudo mv libmwlmgrimpl.so libmwlmgrimpl.bak
sudo cp /path/to/this/repo/libmwlmgrimpl.so .
```

Ensure the license file is in the correct location:
```bash
sudo mkdir -p /usr/local/MATLAB/R2024a/licenses
sudo cp /path/to/this/repo/license.lic /usr/local/MATLAB/R2024a/licenses/
```

### 5. Resolve Library Compatibility (Ubuntu 24.04)
MATLAB bundles an older version of `libstdc++.so.6` that crashes on Ubuntu 24.04. We must force MATLAB to use the system's version:
```bash
cd /usr/local/MATLAB/R2024a/sys/os/glnxa64
sudo mv libstdc++.so.6 libstdc++.so.6.backup
```

### 6. Install the Wrapper and Desktop Shortcut
This repository provides a wrapper script that fixes common permissions and environment issues.
```bash
# Install the wrapper script
sudo cp /path/to/this/repo/matlab /usr/local/bin/matlab
sudo chmod +x /usr/local/bin/matlab

# Install the desktop entry
mkdir -p ~/.local/share/applications
cp /path/to/this/repo/matlab.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications
```

### 7. Cleanup
Unmount the ISO image:
```bash
sudo umount /mnt/matlab
sudo rmdir /mnt/matlab
```

## Troubleshooting

- **Permissions Error**: If you see `mkdir: cannot create directory "/home/user/.MathWorks": Permission denied`, run:
  ```bash
  sudo chown -R $USER:$USER ~/.MathWorks
  ```
- **Library Issues**: If MATLAB fails to start, ensure the `LD_PRELOAD` path in the `/usr/local/bin/matlab` script matches your system (usually `/usr/lib/x86_64-linux-gnu/libstdc++.so.6`).

## Verification
Test the installation by running:
```bash
matlab -batch "disp('MATLAB is working'); exit"
```