# MATLAB Add-on (Toolbox) Installation Guide

This guide explains how to add additional toolboxes (e.g., Deep Learning Toolbox) to an existing MATLAB R2024a installation on Linux.

## Procedure

### 1. Configure the Installer Input File
Edit the `installer_input.txt` located in your installation repository:
- **Set License Path**: Ensure `licensePath` points to the absolute path of your `license.lic`.
- **Select Products**: Find the line for the desired toolbox (e.g., `#product.Deep_Learning_Toolbox`) and remove the `#` to uncomment it.

### 2. Mount the MATLAB ISO
Create a mount point and mount the ISO file:
```bash
sudo mkdir -p /mnt/matlab
sudo mount -o loop /path/to/R2024a_Linux.iso /mnt/matlab
```

### 3. Run the Installation
Execute the installer with the `-E` flag and the input file. The installer will automatically detect the existing installation and only add the newly selected components:
```bash
cd /mnt/matlab
sudo -E ./install -inputFile /path/to/your/repo/installer_input.txt
```

### 4. Cleanup
Unmount the ISO image and remove the mount point:
```bash
sudo umount /mnt/matlab
sudo rmdir /mnt/matlab
```

---

## Verification
To verify the new toolbox is installed, run a command specific to that toolbox in batch mode. For example, for the Deep Learning Toolbox:
```bash
matlab -batch "tansig(1); disp('Deep Learning Toolbox is active'); exit"
```
