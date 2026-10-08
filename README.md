# hdEMG-Signal-Stability-Detection
MATLAB pipeline for automated stable region detection in hdEMG and force signals.
# findMostStableRegion - EMG & Force Signal Stability Detector

A MATLAB utility designed to automatically locate and extract the most stable isometric contraction segment from Electromyography (EMG) or force target signals during biomechanical protocols.

##  Overview
In hdEMG and motor unit analysis, isolating a steady-state (isometric) contraction period with minimal amplitude fluctuations is essential for reliable signal processing. This algorithm utilizes dynamic thresholding for signal onset detection combined with a sliding-window variance analysis to pinpoint the region of maximum stability.

##  Algorithm Workflow
1. **Dynamic Thresholding:** Automatically estimates signal onset and termination boundaries using relative amplitude dynamic ranges (10% and 4% thresholds).
2. **Sliding Window Analysis:** Computes localized variance across user-defined window lengths (`intervalLengthInSamples`).
3. **Optimization:** Identifies the global minimum variance region to establish precise steady-state start (`startSample`) and end (`stopSample`) indices.

##  Inputs & Outputs

### Inputs:
- `ref_signal`: 1D array of the reference signal (e.g., Force, Torque, or EMG Envelope).
- `intervalLengthInSamples`: Window duration for stability evaluation in samples.
- `fsamp`: Signal sampling frequency (Hz).

### Outputs:
- `startSample` / `stopSample`: Boundary indices for the most stable signal segment.
- `startRef` / `stopRef`: Baseline reference and onset boundary estimates.

##  Example Usage
```matlab
% Define parameters
fsamp = 2048; % Sampling frequency in Hz
windowDuration = 5; % 5-second stability window
intervalLengthInSamples = windowDuration * fsamp;

% Run stability detection
[startRef, stopRef, startSample, stopSample] = findMostStableRegion(forceSignal, intervalLengthInSamples, fsamp);

% Extract stable region
stableForce = forceSignal(startSample:stopSample);
