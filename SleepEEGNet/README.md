# SleepEEGNet

This presentation is about **automatic sleep stage classification from EEG signals** using a deep learning method called **SleepEEGNet**.

It focuses on replacing manual sleep scoring with an automated approach that is faster, more scalable, and more objective.

---

## Project Goal

The main goal of this project is to classify sleep stages automatically from EEG recordings.

Specifically, the presentation:
- introduces the problem of manual sleep scoring,
- explains why automation is needed,
- uses EEG data from the **Sleep-EDF** datasets,
- applies a deep learning model,
- and evaluates the method with cross-validation in an inter-patient setting.

---

## Motivation

Sleep staging is usually done manually by experts on **30-second EEG epochs** in polysomnography recordings.

This process is:
- time-consuming,
- subjective,
- and difficult to scale.

So the project aims to build a model that can perform sleep scoring automatically with high accuracy.

---

## Dataset

The presentation uses the **Sleep-EDF** datasets:

- **Sleep-EDF 2013**: 61 PSG recordings
- **Sleep-EDF 2018**: 197 PSG recordings

### EEG Channels
The presentation mentions single-channel EEG inputs:
- **Fpz-Cz**
- **Pz-Oz**

### Preprocessing / Setup
- Epoch length: **30 seconds**
- Imbalanced data handling: **SMOTE**

---

## Methodology

The project uses **SleepEEGNet**, a deep learning-based model for sleep stage classification.

### Main steps
- EEG epochs are extracted from PSG recordings.
- The model learns to classify sleep stages from these signals.
- Performance is evaluated using **k-fold cross-validation**.
- The presentation emphasizes **inter-patient evaluation** to make the results more realistic.

---

## Evaluation

The model is assessed using:
- **k-fold cross-validation**
- **inter-patient evaluation**

This means the method is tested in a way that checks how well it generalizes to unseen subjects.

---

## Structure of the Presentation

The presentation includes:
- Title / introduction
- Motivation for automatic sleep scoring
- Dataset description
- Model description
- Evaluation setup
- References

---

## Summary

This presentation proposes an automated sleep scoring approach based on EEG signals.

In short, it:
- uses **Sleep-EDF** data,
- applies **SleepEEGNet**,
- handles class imbalance with **SMOTE**,
- and evaluates the system using **cross-validation** and **inter-patient testing**.

---

## Note

This is a **presentation about a paper**, not a code project, so there is **no code section** in this README.
