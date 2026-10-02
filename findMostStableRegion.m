function [startRef, stopRef, startSample, stopSample] = findMostStableRegion(ref_signal, intervalLengthInSamples, fsamp)
% FINDMOSTSTABLEREGION Detects the most stable contraction region in EMG/reference signals.
%
% Syntax:
%   [startRef, stopRef, startSample, stopSample] = findMostStableRegion(ref_signal, intervalLengthInSamples, fsamp)
%
% Inputs:
%   ref_signal             - 1D Array of reference signal amplitudes (e.g., Target Force/EMG Envelope)
%   intervalLengthInSamples - Length of the analysis window in samples
%   fsamp                  - Sampling frequency in Hz
%
% Outputs:
%   startRef   - Initial reference index (Default: 1)
%   stopRef    - Estimated onset boundary index
%   startSample- Start index of the most stable region (minimum variance)
%   stopSample - End index of the most stable region
%
% Description:
%   This algorithm uses a sliding window variance analysis to pinpoint the most
%   stable segment of isometric contractions during hdEMG/force protocols.

    % Input Validation
    arguments
        ref_signal (1,:) double
        intervalLengthInSamples (1,1) double {mustBePositive, mustBeInteger}
        fsamp (1,1) double {mustBePositive}
    end

    % Initialization
    startRef = 1;
    signalRange = max(abs(ref_signal)) - min(abs(ref_signal));

    % Detect Signal Onset Thresholds (10% and 4% Dynamic Range)
    onsetThresholdHigh = ref_signal(1) + (signalRange / 10);
    stopRefCandidates = find(ref_signal > onsetThresholdHigh, 1, 'first');
    
    if isempty(stopRefCandidates)
        stopRef = round(fsamp / 2);
    else
        stopRef = max(round(fsamp / 2), stopRefCandidates - round(fsamp / 2));
    end

    onsetThresholdLow = ref_signal(1) + (signalRange / 25);
    stopSigCandidates = find(ref_signal > onsetThresholdLow, 1, 'last');
    
    if isempty(stopSigCandidates)
        stopSig = length(ref_signal);
    else
        stopSig = stopSigCandidates;
    end

    % Sliding Window Variance Calculation
    numSamples = length(ref_signal);
    varRef = inf(1, numSamples - intervalLengthInSamples);

    for idx = stopRef : (stopSig - intervalLengthInSamples)
        windowSegment = ref_signal(idx : idx + intervalLengthInSamples);
        varRef(idx) = var(windowSegment);
    end

    % Identify Segment with Minimum Variance
    [~, startSample] = min(varRef);
    stopSample = startSample + intervalLengthInSamples;

end