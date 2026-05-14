# GNSS Time-Series Modeling and Correction (Taiwan, 2010-2024)

This repository provides MATLAB scripts for modeling continuous GNSS (cGNSS) time series using a standardized framework. The workflow reproduces the processing strategy used to generate the Taiwan GNSS dataset (2010-2024).

---

## Overview

The scripts implement a time-series model including:

- Linear trend (velocity)
- Annual and semiannual seasonal signals
- Step functions (offsets, instrumental changes, earthquakes)
- Optional postseismic exponential terms

---

## Important Note

This repository provides **modeling and processing scripts only**.

The final processed GNSS products (e.g., corrected time series in `.neu` format, velocity fields, and coseismic displacements) are available in the Zenodo dataset associated with this study.

---

## Repository Structure
.
¢u¢w¢w run_timeseries_modeling.m # Main script
¢u¢w¢w functions/ # Core modeling functions
¢u¢w¢w metadata/
¢x ¢|¢w¢w events.csv # Event metadata
¢|¢w¢w data/ # Example input (*.series)


---

## Input Data Format

The scripts expect GNSS time series in `.series` format:


time (decimal year), East, North, Up, sigmaE, sigmaN, sigmaU


- Time must be in decimal year
- Units can be meters or millimeters (controlled by `config.positionScale`)

---

## Event Metadata

`metadata/events.csv` must contain:

station,time,type

where:
- `time` is in decimal year
- `type` {`offset`, `instrument`, `earthquake`}

---

## Usage

Run the main script:

```matlab
run_timeseries_modeling

The script will:

Read .series files
Fit the time-series model
Apply outlier removal
Return results in memory
Optional Settings
config.makeFigure = false;   % generate diagnostic plots
Model Description

The standard deviation of residuals (SDR), used as a key quality metric in this study, is computed directly from the residuals of the time-series model after outlier removal. 
This calculation is implemented within the modeling scripts provided in this repository.

Requirements
MATLAB (R2020 or newer recommended)
No additional toolboxes required
Citation

If you use this code, please cite the associated dataset:

Taiwan GNSS Dataset (2010-2024), Zenodo, DOI: 10.5281/zenodo.20047819

License

MIT License
