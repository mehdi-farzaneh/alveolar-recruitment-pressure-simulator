# Alveolar Recruitment Pressure Simulation

## Project overview

This project presents a computational framework for modeling alveolar recruitment and simulating airway pressure dynamics under varying physiological conditions. The software implements a parameter-driven recruitment model that enables systematic exploration of how lung compliance, resistance, flow, opening pressure, and pressure-range inputs influence airway pressure over time. By combining a modular MATLAB implementation with a user-friendly graphical interface, the project

## Purpose

The application is designed to study the relationship between alveolar recruitment parameters and airway pressure during inspiration. In particular, it allows the user to adjust model inputs such as:

- CL: lung compliance
- C_FRC: functional residual capacity compliance
- TOP: opening pressure threshold
- K: recruitment rate constant
- R: resistance
- Q: flow
- N: recruitment index
- tinsp: inspiration duration
- SP: pressure range used in the recruitment model

The simulation produces a pressure curve over time, which helps visualize how the recruited alveolar volume changes with condition-specific parameters.

## Repository structure

- `alveolarRecruitmentGUI.m` — main entry point to launch the MATLAB GUI
- `+LungRecruitment/Parameters.m` — parameter defaults, loading, saving, and validation
- `+LungRecruitment/Simulation.m` — alveolar recruitment model and pressure simulation solver
- `+LungRecruitment/Theme.m` — user interface color scheme
- `+LungRecruitment/UI.m` — graphical user interface and callbacks
- `sample_patient.mat` — example patient data used for testing or demonstration

## How to run

Open MATLAB in this folder and run:
"alveolarRecruitmentGUI"

Note: The GUI supports loading a saved parameter set from a `.mat` file and plotting the resulting airway pressure response.

## Authors / Affiliation

This project was developed as part of the Computer Math lecture. If this work is intended for a thesis, manuscript, or academic submission, please add the relevant authors and institutional affiliation below.

- Author: Mohammad Mehdi Farzaneh
- Affiliation: Faculty of Engineering and Technology, Furtwangen University
- Supervisor: Dr. Kretschmer
