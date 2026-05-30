# Psychophysics

This project analyzes face recognition performance under different spatial frequency conditions:
- **Low frequency**
- **High frequency**
- **Intact**

It also includes psychometric curve fitting, model comparison using **AIC**, and analysis of response data.

---

## Project Goal

The main goal of this project is to study how humans recognize facial identity when visual information is filtered at different spatial frequencies.

Specifically, the project:
- filters face images to remove or preserve certain frequency information,
- tests recognition performance across different morph levels,
- fits psychometric functions to participant responses,
- compares model quality using **AIC**,
- and evaluates recognition patterns across conditions.

---

## Experimental Design

### Stimuli
- Two face pairs were used.
- Each pair was morphed across **7 levels**.
- Images were filtered into:
  - **Low spatial frequency**
  - **High spatial frequency**
  - **Intact**
- In total, **42 stimuli** were created.

### Blocks
The experiment consisted of **4 blocks**:
- 3 blocks for the single-frequency conditions
- 1 mixed block with randomly selected images from all conditions

### Trial Structure
- Participants first learned face-name associations.
- A training phase continued until each face was identified correctly **3 times in a row**.
- In the main task:
  - each stimulus was shown for **400 ms**
  - then two name options appeared
  - participants had **3 seconds** to respond

### Total Trials
- **1344 trials**
- Calculated as: `42 images × 32 repetitions`

---

## Data Format

The project uses two CSV files:

### `subjectInfo`
Contains participant information such as:
- `age`
- `Sex`
- `dom` (dominant hand)

### `data`
Contains trial-level data such as:
- `trialKeys`
- `levelFreq`
- `levelFace`
- `lCueName`
- `rCueName`
- `srespLoc`
- `srespChoice`
- `RT`
- `Hand`
- `blockType`
- `subjectID`

---

## Methodology

### Psychometric Fitting
The response data was modeled using psychometric functions:

#### 1. Sigmoid Function
A standard sigmoid model with parameters:
- `alpha`
- `beta`

#### 2. Modified Sigmoid Function
A more flexible model with parameters:
- `alpha`
- `beta`
- `y`
- `lambda`

### Model Fitting
- Fitting was performed using the **SciPy** library
- Optimization was based on **Residual Sum of Squares (RSS)**

### Model Comparison
- Models were compared using **AIC (Akaike Information Criterion)**
- AIC was used to balance:
  - goodness of fit
  - model complexity

---

## Results

The report includes:
- scatter plots of response data
- sigmoid fitting plots
- fitting results for the first subject
- comparisons between the simple and modified sigmoid models

### Main Finding
- The **modified sigmoid** generally fits the data better than the simple sigmoid
- However, in some cases, the simple sigmoid performed better

---

## Structure of the Report

The original report is organized into the following sections:
- Abstract
- Task Description
- Data Format
- Psychometric Fitting
- ROC Curve
- Make a Hypothesis!
- Conclusion

---

## Tools and Libraries

- **Python**
- **SciPy**
- Data analysis and psychometric curve fitting

