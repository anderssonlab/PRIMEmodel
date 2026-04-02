# PRIMEmodel Installation Preparation Guide

This guide explains how to set up the required **R** and **Python** environments to use the `PRIMEmodel` R package.

```bash
# In terminal
git clone https://github.com/anderssonlab/PRIMEmodel.git
```

For macOS users: libomp is required for LightGBM to enable OpenMP (multithreading). Without libomp, LightGBM may fail to use multithreading properly and can produce silent errors or crashes during training without clear messages. (To follow this setup, Xcode Command Line Tools and Homebrew are required.)

```bash
# Check if libomp exists

## Apple Silicon (M1/M2/M3/...)
ls /opt/homebrew/opt/libomp/lib/libomp.dylib
## Intel macOS (x86_64)
ls /usr/local/opt/libomp/lib/libomp.dylib
```

```bash
# If libomp does not exist
brew install libomp
```
On macOS, R (via homebrew libomp) and Python environments (via conda or virtualenv libomp) can conflict when used together through reticulate, potentially causing crashes with errors. If this occurs, managing environment variables or aligning libomp paths may be necessary to avoid conflicts while maintaining multithreaded performance.

---

## R Installation for PRIMEmodel

The R package `PRIMEmodel` depends on a mix of CRAN and Bioconductor packages, and a custom GitHub version of `PRIME`.

Note that we recommend using R 4.4 or higher. While R versions >4.2 can also be used, they may require additional setup steps. For example, on macOS, you may need to run:
```bash
# core build tools for R packages
brew install gcc pkg-config

# libraries for graphics, fonts, and rendering
brew install freetype harfbuzz fribidi libpng cairo

# libraries for image support
brew install jpeg libpng libtiff

# version control and Git support
brew install libgit2
```
when using R 4.2 to install system libraries required for building certain R packages from source.

Optional (Recommended for macOS users on R 4.2.x):
To avoid X11-related warnings and enable x11() graphics, install XQuartz. This is not required if you only use RStudio or file-based plots, but it ensures maximum compatibility with all packages and plotting functions in R.

### Full R Setup
CAGEfightR (install via Bioconductor) and PRIME (from https://github.com/anderssonlab/PRIME) are needed for installing PRIMEmodel. Before installing, additional packages need to be installed.

```bash
R
```

1. Install required CRAN packages
```r
install.packages(c(
  "R.utils",
  "assertthat",
  "data.table",
  "future",
  "future.apply",
  "future.callr",
  "foreach",
  "argparse",
  "doParallel",
  "reticulate",
  "arrow",
  "stringr",
  "magrittr"
))
```

2. Install BiocManager (if not already installed)
```r
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
```

3. Install devtools (if not already installed)
```r
if (!requireNamespace("devtools", quietly = TRUE))
  install.packages("devtools")
```

4. Install CAGEfightR and PRIME
If errors occur from prerequisite packages, the full installation protocol for PRIME can be found at: https://github.com/anderssonlab/PRIME/blob/main/PRIME_installation.md
```r
BiocManager::install("CAGEfightR")
devtools::install_github("anderssonlab/PRIME")
```

5. Install additional Bioconductor packages (not installed with PRIME)
```r
BiocManager::install("sparseMatrixStats")
```

6. Install PRIMEmodel
```r
## Install from a local .tar.gz (the model will be set up in the PRIME installation directory):
install.packages("/PATH/TO/PRIMEmodel/PRIMEmodel_1.0.tar.gz")
```
Alternatively, if installing via devtools, make sure that the model exists in the path. The published PRIMEmodel model can be found at: https://doi.org/10.5281/zenodo.17142494

---

## 🐍 Python Environment Setup

You can prepare the Python environment in different ways. 
---

### 🔧 Option 1: Use existing Python installation by installing required packages indicated in `requirements.txt`

If you already have a working Python installation and want to use it directly:

```bash
cd PRIMEmodel

# Install the required packages
pip3 install -r inst/envfile/environment.txt

# Check the path to python
# Use this path in PRIMEmodel functions
which python3
```

#### Example usage: check the completeness of the installation in R
```r
# in R
library(GenomicRanges)
library(PRIMEmodel)

plc_focal_example <- PRIMEmodel::predictFocalExample(python_path = "/PATH/TO/YOUR/PYTHON")
plc_example <- PRIMEmodel::predictExample(python_path = "/PATH/TO/YOUR/PYTHON")
```

### 🔧 Option 2 : Virtualenv via `reticulate` in R

This is the method for setting up the Python environment using only R.

Reticulate virtualenv (in R) is easiest for R-focused workflows without needing external software, **but requires running `use_virtualenv()` in each session** and is not ideal for CLI use.

#### Setup instructions in R:

```bash
cd PRIMEmodel
R
```

```r
library(reticulate)

# Define the environment name
env_name <- "prime-env"

# Create the virtual environment if it doesn't exist
virtualenv_create(envname = env_name)

# Use and configure it
use_virtualenv(env_name, required = TRUE)

# Install Python packages
required_pkgs <- readLines(system.file("envfile", "environment.txt", package = "PRIMEmodel"))
reticulate::py_install(packages = required_pkgs, envname = env_name, method = "virtualenv")

# Confirm active Python path
py_config()$python
```

#### Example usage: check the completeness of the installation in R
```r
# in R
library(GenomicRanges)
library(PRIMEmodel)

plc_focal_example <- PRIMEmodel::predictFocalExample(python_path = py_config()$python)
plc_example <- PRIMEmodel::predictExample(python_path = py_config()$python)
```

---

### 🔧 Option 3: Conda

`environment.yml` is included in the `inst/envfile` folder.

#### How to create the environment:

```bash
cd PRIMEmodel

conda env create -f inst/envfile/environment.yml

# Activate the environment
conda activate prime-env

which python3
# Copy this path to use as python_path in R when calling PRIMEmodel::predictExample() or PRIMEmodel::predictFocalExample()

conda deactivate
```

#### Example usage: check the completeness of the installation in R
```r
# in R
library(GenomicRanges)
library(PRIMEmodel)

plc_focal_example <- PRIMEmodel::predictFocalExample(python_path = "~/.conda/envs/prime-env/bin/python3")
plc_example <- PRIMEmodel::predictExample(python_path = "~/.conda/envs/prime-env/bin/python3")
```

---

### 🔧 Option 4: Virtualenv (manual setup)

This is an advanced manual option for setting up the environment outside of R. It is useful if managing environments via shell or external tools.

#### Setup instructions

```bash
cd PRIMEmodel

# Python virtual environmetn set up
python3 -m venv ~/prime_env
source ~/prime_env/bin/activate
pip3 install -r inst/envfile/environment.txt

which python3
# Copy this path to use as python_path in R when calling PRIMEmodel::predictExample() or PRIMEmodel::predictFocalExample()

deactivate
```

#### Example usage: check the completeness of the installation in R
```r
# in R
library(GenomicRanges)
library(PRIMEmodel)

plc_focal_example <- PRIMEmodel::predictFocalExample(python_path = "~/prime_env/bin/python3")
plc_example <- PRIMEmodel::predictExample(python_path = "~/prime_env/bin/python3")
```

---


---

## 🧠 Tips
- If you don’t have full control over your R and Python environments, errors may occur when they try to communicate. We recommend setting up a dedicated virtual environment (such as a conda environment). You can find an example here [https://github.com/anderssonlab/PRIMEmodel/blob/main/KUIT_user/KUIT_PRIME_SETUP_CONDA.md].
- Always check the current Python path with `which python3` **after** activating your environment.
- Use that full path in the `python_path` argument in R.
---

© 2025 PRIMEmodel setup protocol
