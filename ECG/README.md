# EEG

This project analyzes EEG responses in a visual RSVP task with **faces** and **dollhouses**.  
It includes preprocessing, ERP analysis, time-frequency analysis, MVPA, RDM, and RSA.

---

## Project Goal

The main goal of this project is to become familiar with EEG data analysis and explore how brain activity reflects visual object recognition.

Specifically, the project:
- preprocesses raw EEG signals,
- studies event-related potentials,
- examines time-frequency patterns,
- applies multivariate pattern analysis,
- and uses representational similarity methods.

---

## Experimental Design

### Paradigm
- The experiment used an **RSVP (Rapid Serial Visual Presentation)** paradigm.
- Stimuli belonged to two categories:
  - **faces**
  - **dollhouses**

### Stimuli
- **18 images** were used in total.
- Each image was shown **4 times**.
- This produced **72 stimulus presentations** overall.

### Trial Structure
- Each stimulus was displayed for **100 ms**
- The inter-stimulus interval was **2000 ms**
- Participants were instructed to maintain fixation

### EEG Setup
- **64-channel EEG**
- **10–10 electrode system**
- **Sampling rate:** 1000 Hz
- **Online filters:** 0.1 Hz high-pass and 100 Hz low-pass
- **Reference:** Fz electrode
- **Trigger channel:** channel 64
  - **496#** = face
  - **436#** = dollhouse

---

## Data Format

The report uses raw EEG recordings with event markers stored in the trigger channel.

After preprocessing:
- FPz, IO, and Fz are removed from the scalp location set
- the remaining data are treated as **63-channel EEG**

---

## Methodology

### Preprocessing
The preprocessing pipeline includes:
- loading raw EEG data
- inspecting data information
- identifying events
- loading scalp electrode locations
- removing unnecessary channels from the location set
- applying a **1 Hz high-pass filter**
- re-referencing using the **average reference**

### Analysis Pipeline
The report then continues with:
- **ERP**
- **Time-Frequency Analysis**
- **MVPA**
- **RDM**
- **RSA**

---

## Report Structure

The report is organized into the following sections:
- Abstract
- Task paradigm
- Preprocessing
- Event-Related Potential (ERP)
- Time-Frequency Analysis
- MultiVariate Pattern Analysis (MVPA)
- Representational Dissimilarity Matrices / Similarity Analysis (RDM & RSA)
- Subject-wise analyses for multiple subjects

---

## Tools and Libraries

- **EEGLAB**
- EEG hardware and signal-processing workflow
- traditional and multivariate EEG analysis methods
