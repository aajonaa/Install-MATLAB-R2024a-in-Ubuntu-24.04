# MATLAB R2024a Installation Guide for Ubuntu 24.04 (AI-Friendly)

This guide provides a structured process for installing MATLAB R2024a on Ubuntu 24.04. It is designed for both human users and AI agents (like Gemini CLI) to execute reliably.

## Prerequisites
1.  **MATLAB R2024a ISO**: `R2024a_Linux.iso`
2.  **This Repository**: Contains `license.lic`, `libmwlmgrimpl.so`, `matlab` wrapper, and `installer_input.txt`.

---

## Technical Automation Flow (For AI Agents)

To install MATLAB automatically, follow these precise steps:

### 1. Identify Paths
Identify the absolute path to this repository (`REPO_PATH`) and the ISO file (`ISO_PATH`).

### 2. Prepare Installer Input
The `installer_input.txt` file must be updated with the absolute path to the license file.
- **Action**: Replace `licensePath=...` in `installer_input.txt` with `licensePath=<REPO_PATH>/license.lic`.
- **Action**: Ensure `product.MATLAB` is uncommented.

### 3. Mount and Install
```bash
sudo mkdir -p /mnt/matlab
sudo mount -o loop <ISO_PATH> /mnt/matlab
cd /mnt/matlab
sudo -E ./install -inputFile <REPO_PATH>/installer_input.txt
```

### 4. Patch License Manager
```bash
# Path to the plugin directory
PLUGINS_DIR="/usr/local/MATLAB/R2024a/bin/glnxa64/matlab_startup_plugins/lmgrimpl"
sudo mv "$PLUGINS_DIR/libmwlmgrimpl.so" "$PLUGINS_DIR/libmwlmgrimpl.bak"
sudo cp "<REPO_PATH>/libmwlmgrimpl.so" "$PLUGINS_DIR/"
```

### 5. Finalize Licensing
```bash
sudo mkdir -p /usr/local/MATLAB/R2024a/licenses
sudo cp "<REPO_PATH>/license.lic" /usr/local/MATLAB/R2024a/licenses/license.lic
```

### 6. Fix Ubuntu 24.04 Compatibility
MATLAB's internal `libstdc++.so.6` is incompatible with Ubuntu 24.04. Force the use of the system library:
```bash
sudo mv /usr/local/MATLAB/R2024a/sys/os/glnxa64/libstdc++.so.6 /usr/local/MATLAB/R2024a/sys/os/glnxa64/libstdc++.so.6.backup
```

### 7. Install System Integration
```bash
# Install wrapper script
sudo cp "<REPO_PATH>/matlab" /usr/local/bin/matlab
sudo chmod +x /usr/local/bin/matlab

# Install desktop entry
mkdir -p ~/.local/share/applications
cp "<REPO_PATH>/matlab.desktop" ~/.local/share/applications/
update-desktop-database ~/.local/share/applications
```

### 8. Cleanup
```bash
sudo umount /mnt/matlab
sudo rmdir /mnt/matlab
```

---

## Verification Command
Run the following to confirm a successful headless installation:
```bash
matlab -batch "disp('MATLAB R2024a Installation Successful'); exit"
```
