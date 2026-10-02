% MAIN_DEMO - Demonstration of Stable EMG Signal Region Detection
clear; clc; close all;

% 1. Generate Synthetic Isometric Force / EMG Signal
fsamp = 2000; % 2000 Hz Sampling Rate
t = 0:1/fsamp:10; % 10 seconds

% Simulate force ramp up, plateau with noise, and ramp down
force_profile = [zeros(1, 2*fsamp), ...
                 linspace(0, 50, 2*fsamp), ...
                 50 + randn(1, 4*fsamp)*1.5, ... % Stable Plateau
                 linspace(50, 0, 2*fsamp)];

intervalLength = 2 * fsamp; % 2-second stability window

% 2. Run Stability Detection
[startRef, stopRef, startSample, stopSample] = findMostStableRegion(force_profile, intervalLength, fsamp);

% 3. Visualization
figure('Color', [1 1 1]);
plot(t, force_profile, 'k-', 'LineWidth', 1.5); hold on;
xline(t(startSample), 'r--', 'Start of Plateau', 'LineWidth', 2);
xline(t(stopSample), 'g--', 'End of Plateau', 'LineWidth', 2);
patch([t(startSample) t(stopSample) t(stopSample) t(startSample)], ...
      [min(force_profile) min(force_profile) max(force_profile) max(force_profile)], ...
      'y', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

title('Detection of Most Stable Contraction Region (hdEMG Analysis)');
xlabel('Time (s)'); ylabel('Force / Signal Amplitude');
grid on;