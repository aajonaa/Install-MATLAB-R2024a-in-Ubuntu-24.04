# Headless MATLAB Running Guide (136opt Project)

This guide explains how to replicate the MATLAB GUI "Run" behavior on a headless Linux server for the `136opt` project. This is critical for resolving dependency issues like "Cannot open input file" or "Segmentation violations" caused by missing data files.

## Local Paths on this Machine
- **Project Repository:** `/home/jona/github/136opt`
- **MATLAB ISO File:** `/data/matlab/R2024a_Linux.iso`
- **Installation Repo (for Add-ons):** `/data/matlab/Install-MATLAB-R2024a-in-Ubuntu-24.04`

---

## The Core Concept
In the GUI, you usually have the **Current Folder** set to the project root (`136opt`) while running a script located in a subfolder (like `WangJianFolder`). Headless MATLAB must replicate this exact environment.

## Execution Command

Run the following command from your Linux terminal:

```bash
/usr/local/MATLAB/R2024a/bin/matlab -batch "addpath('/home/jona/github/136opt/WangJianFolder'); cd('/home/jona/github/136opt'); ImproveTest_v2"
```

### Breakdown of the Command:
1.  **`/usr/local/MATLAB/R2024a/bin/matlab`**: The absolute path to the MATLAB binary. Bypassing the wrapper script ensures no GUI attempt is made.
2.  **`-batch`**: Runs MATLAB in a non-interactive mode. It redirects output to the terminal and exits automatically upon completion or error.
3.  **`addpath('/home/jona/github/136opt/WangJianFolder')`**: Makes the target script visible to MATLAB.
4.  **`cd('/home/jona/github/136opt')`**: **Crucial Step.** This sets the working directory to the project root. Many dependencies (like CEC MEX files) look for input data files (e.g., `M_1_D10.txt`) relative to this root.
5.  **`ImproveTest_v2`**: The name of the script to execute.

---

## Running in the Background (Nohup)

For long experiments, use `nohup` to prevent the process from being killed if your SSH session disconnects:

```bash
nohup /usr/local/MATLAB/R2024a/bin/matlab -batch "addpath('$(pwd)/WangJianFolder'); cd('$(pwd)'); ImproveTest_v2" > experiment_output.log 2>&1 &
```

-   **`> experiment_output.log`**: Saves all Command Window output to a file.
-   **`2>&1`**: Captures error messages in the same log file.
-   **`&`**: Runs the process in the background.

## Troubleshooting
-   **Segmentation Violation**: Usually means a MEX file is called but cannot find its required `.txt` or `.dat` files. Ensure your `cd()` command points to the folder containing the `input_data/` directories.
-   **Function Not Found**: Ensure you have added the folder containing the script to the path using `addpath()`.