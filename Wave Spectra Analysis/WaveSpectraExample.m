% OCE2901 - Wave Spectra Analysis Example
% Braidan Duffy
% 03/13/21
% Example on wave spectra calculation and plotting from Ocean Wave Analysis
% by Arash Karimpour

% Input
duration = 1024; % Total duration of time series
fs = 2; % Hz - sampling frequency

% Generating time vector
dt = 1/fs; % s - time difference between samples
t = 0:dt:duration-dt; % Generate time vector

eta = 0.5*cos(2*pi*0.2*t); % Generate surface time series with a=0.5m, f=0.2Hz
rnd = -0.1+(0.1-(-0.1)) .* rand(1, length(t)); % Generate random noise
eta = eta+rnd; % Add random noise to signal
eta = detrend(eta); % Detrend signal

%% Calculate PSD Manually
% Generating frequency vector
N = length(eta); % Length of frequency vector
df = fs/N; % Frequency difference between samples
f = 0:df:fs/2; % Generate frequency vector from 0 Hz to f_nyq

% Begin spectral analysis
etaFFT = fft(eta); % Convert eta from time space to frequency space
etaFFT = etaFFT(1:length(f)); % Trim fft data to length of frequnecy vector
psd_eta_2sided = (1/(N*fs))*(abs(etaFFT)).^2; % m^2/Hz - Calculate Power Spectral Density (PSD)
psd_eta_1sided = psd_eta_2sided;
psd_eta_1sided(2:end-1) = 2.*psd_eta_1sided(2:end-1); % Fold over 1 sided PSD

% Plotting eta over time
figure(1)
plot(t, eta)
title("Water Surface Elevation over Time")
xlabel("Time (s)")
ylabel("Surface Elevation (m)")

% Plotting PSD over frequency
figure(2)
semilogy(f, psd_eta_1sided)
title("Power Spectral Density")
xlabel("Frequency (Hz)")
ylabel("Power Density (m^2/Hz)")

%% Calculate PSD Using function

[psd_eta_1sided_pgram, f_pgram] = periodogram(eta, [], N, fs);

semilogy(f_pgram, psd_eta_1sided_pgram, 'b')
title("Power Spectral Density")
xlabel("Frequency (Hz)")
ylabel("Power Density (m^2/Hz)")

%% Calculate Wave Parameters from PSD
m0 = sum(psd_eta_1sided .* f.^1 .* df); % zero-moment of PSD
m1 = sum(psd_eta_1sided .* f.^1 .* df); % first-moment of PSD
m2 = sum(psd_eta_1sided .* f.^2 .* df); % second-moment of PSD

Hm0 = 4 * sqrt(m0); % zero-moment wave height

% Finding peak period and frequency
[psd_eta_max, max_idx] = max(psd_eta_1sided);
f_peak = f(max_idx);    % Hz - Peak frequency
T_peak = 1/f_peak;      % s - Peak period
Tm01 = m0/m1;           % s - mean period
Tm02 = (m0/m2)^0.5;     % s - zero-crossing period

%% Testing wave_spectra()

[f, psd_eta_1sided_func, Hm0, Tm01, Tm02, T_peak, f_peak] = wave_spectra(eta, fs);
semilogy(f, psd_eta_1sided_func, 'b')
title("Power Spectral Density")
xlabel("Frequency (Hz)")
ylabel("Power Density (m^2/Hz)")