# tMKL
Resting State Dynamics Meets Anatomical Structure:  Temporal Multiple Kernel Learning (tMKL) Model

# Dependencies
python3 [sklearn](http://scikit-learn.org/stable/install.html)

# Get Started
Open matlab and run the following:
```
run <tMKL_dir_path>/CODE/main_script.m
```

# Directory Description

1. CODE - contains scripts and functions
..* main_script.m - main script for running tMKL
..* get_train_struct.m - wFCs generation, vectorize wFCs, spectral embedding - projection to manifold, GMM - assign wFCs to states
..* run_tMKL.m - run MKL model for every state
..* grand_average_prediction.m - evaluate model performance
2. INPUT_MATS - stores the data, including SC FC matrices and BOLD timeseries data.
3. INTER_MATS - stores intermediate representations : wFCs, cluster assignments, transition matrices, tMKL model parameters etc.
4. OUTPUT_MATS - stores final model performance results
