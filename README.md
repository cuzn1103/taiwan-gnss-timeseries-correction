# GNSS Time-Series Modeling and Correction (Taiwan, 2011¡V2025)

This repository provides MATLAB scripts for modeling continuous GNSS (cGNSS) time series using a standardized framework. The workflow reproduces the processing strategy used to generate the Taiwan GNSS dataset (2011¡V2025).

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
- `type` ? {`offset`, `instrument`, `earthquake`}

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

The model is:

y(t) = a + bt
     + c cos(2£kt) + d sin(2£kt)
     + e cos(4£kt) + f sin(4£kt)
     + £U step functions (offsets, instrument, earthquakes)
     + £U postseismic exponential terms (optional)

where:

a = offset
b = linear velocity
seasonal terms represent annual and semiannual signals
Outlier Removal

Outliers are defined as:

|residual| > k ¡Ñ £m

where:

£m = sqrt(£U residual2 / N)

An epoch is removed if any component (E, N, or U) exceeds the threshold.

The standard deviation of residuals (SDR), used as a key quality metric in this study, is computed directly from the residuals of the time-series model after outlier removal. 
This calculation is implemented within the modeling scripts provided in this repository.

Requirements
MATLAB (R2020 or newer recommended)
No additional toolboxes required
Citation

If you use this code, please cite the associated dataset:

Taiwan GNSS Dataset (2011¡V2025), Zenodo, DOI: XXXXX

License

MIT License