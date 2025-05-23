# Reserves Calculation in Life Insurance

> This was one of my first small MATLAB projects during my bachelor's studies.  
> The goal was to gain practical experience with actuarial calculations and scripting in MATLAB.

This project implements a basic reserve calculation model for life insurance using MATLAB. The reserve is calculated based on actuarial assumptions and mortality data provided in an Excel table.


## Overview

The goal of this script is to compute the present value of future liabilities under a typical life insurance contract using the net premium method. The implementation is intended for academic or illustrative purposes.

## Files

- `reserves_calculation.m`: Core MATLAB script for performing the calculations.
- `Sterbetafel.xlsx`: Mortality table used as input data.

## Requirements

- MATLAB (R2020b or newer recommended)
- No additional toolboxes required

## Usage

1. Place both files (`reserves_calculation.m` and `Sterbetafel.xlsx`) in the same directory.
2. Open MATLAB and run the script:
   ```matlab
   reserves_calculation

## Output Example

The following histogram shows the distribution of simulated reserves at the end of the contract term. The vertical red line indicates the mean of all simulated values.

![Simulated Reserves](Reserves_Life_Insurance/reserves_output.png)
