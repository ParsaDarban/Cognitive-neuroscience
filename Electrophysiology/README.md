# Electrophysology

This report contains **two separate and unrelated parts**:

1. **Spike Sorting / ROSS**
2. **Analysis of Single Neuron Activity**

These two sections are not connected and should be treated as **independent projects**.

---

## Project 1: Spike Sorting / ROSS

This part focuses on analyzing raw electrophysiology recordings and extracting spike events from neural signals.  
It includes spike detection, noise inspection, and clustering-based spike sorting using **ROSS**.

### Project Goal
The main goal of this part is to identify spike events from a recorded neural signal and sort them into neuron-related clusters.

Specifically, this section:
- loads and visualizes the raw signal,
- analyzes the signal distribution,
- estimates noise characteristics,
- applies threshold-based spike detection,
- and compares clustering methods for autosorting.

### Methodology

#### Signal Inspection
- The signal is plotted using the sampling frequency to reconstruct time.
- The raw waveform is inspected visually.
- A histogram of the signal is used to study its distribution.

#### Noise Analysis
- The signal distribution is fit with a normal model / KDE.
- The noise is described as approximately Gaussian.
- Mean and variance are used to support this interpretation.

#### Spike Detection
- Spike detection is performed using the **median method**.
- The filter order used is **7**.

#### Spike Sorting with ROSS
- The **ROSS** application is used for autosorting and clustering.
- Several clustering methods are tested and compared.

### Clustering / Models Mentioned
The report mentions approaches such as:
- **PCA + t-distribution + k-means**
- **PCA + skew-t distribution + GMM**

In one case, the number of PCA components is **3**.

### Tools and Concepts
- **ROSS**
- **PCA**
- **k-means**
- **GMM**
- **t-distribution**
- **skew-t distribution**
- **median thresholding**

---

## Project 2: Analysis of Single Neuron Activity

This part is about studying how single neurons encode information through spike activity.  
It analyzes spike patterns over time and uses them to decode stimulus category information.

### Project Goal
The main goal of this part is to investigate single-neuron coding and determine whether stimulus category can be predicted from spike data.

Specifically, this section:
- studies spike timing as a neural code,
- computes variability measures over time windows,
- compares activity across stimulus categories,
- and trains a classifier to predict category from neural responses.

### Methodology

#### Neural Variability Analysis
- The report computes the **Mean-Matched Fano Factor (MMFF)**.
- MMFF is evaluated across time windows.
- For each neuron and time window, a regression line is fit and its slope is used as the MMFF estimate.

#### Category Comparison
- MMFF values are compared across categories.
- The **Face** category has the **lowest MMFF**.

This suggests that face stimuli produce:
- higher sensitivity,
- greater precision,
- and more consistent responses across trials.

#### Decoding / Classification
- A machine learning model is trained on spike data.
- The task is framed as a **4-class classification** problem.
- Accuracy is used as the evaluation metric.
- The random baseline is **25%**.

### Tools and Concepts
- **Mean-Matched Fano Factor (MMFF)**
- **Regression slope**
- **Machine learning classifier**
- **Accuracy**
- **Four-category decoding**

---

## Report Structure

The report is organized into two separate sections:

### Part 1
- Abstract
- Spike Sorting
- ROSS

### Part 2
- Analysis of Single Neuron Activity

---

## Summary

- The first part studies **spike sorting** from raw electrophysiology data and uses **ROSS** for clustering.
- The second part studies **single-neuron activity** and uses **MMFF** and classification to analyze neural coding.
- These two parts are **independent** and should not be merged into one combined project description.
