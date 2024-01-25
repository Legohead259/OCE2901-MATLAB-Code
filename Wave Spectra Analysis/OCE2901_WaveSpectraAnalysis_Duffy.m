% OCE2901 - Wave Spectra Analysis
% Braidan Duffy
% 03/13/21

%% Sine Wave Analysis
% create a sine wave with amplitude of 1 sec and period of 10 seconds.   
% Use the spectral analysis code to compute the average Hm0, Tm01, Tm02, peak period

A = 1; % m
T = 10; % s
dx = 0.001; % Interval between samples

x_values = 0:dx:2*pi;
sine_eta = A * sin(T * x_values);

% ----------Spectral analysis----------

[f, psd, Hm0, Tm01, ~, T_peak] = wave_spectra(sine_eta, 1/dx);

% Plotting
figure(4)
semilogy(f, psd)
title("Power Spectral Density (Sine wave)")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (m^2/Hz)")

% Display
disp("Sine Wave Spectra Analysis:")
fprintf("Significant wave height (Hm0): %.3f m\n", Hm0)
fprintf("Average wave period (Tm01):    %.3f s\n", Tm01)
fprintf("Average wave period (Tm02):    %.3f s\n", Tm01)
fprintf("Peak wave period:              %.3f s\n\n", T_peak)

% ----------Wave-by-wave analysis----------

[delims, H_avg, H_s, H_rms, T_avg, T_s] = wave_by_wave(sine_eta, 1/dx);
disp("Sine Wave-by-Wave Analysis:");
fprintf("Average wave height:       %.3f m\n", H_avg)
fprintf("Significant wave height:   %.3f m\n", H_s)
fprintf("RMS wave height:           %.3f m\n", H_rms)
fprintf("Average wave period:       %.3f s\n", T_avg)
fprintf("Significant wave period:   %.3f s\n\n", T_s)

% Plotting - DEBUG
% figure(2)
% plot(x_values, sine_wave, "-k")
% yline(0, "--b")
% for i=1:length(delims)
%     xline(delims(i)*dx, "-.r")
% end
% title("Sine Wave Data")
% xlabel("Time (s)")
% ylabel("Eta (m)")

% ----------Comparison----------

disp("Sine Wave Analysis Comparison:")
fprintf("Significant wave height difference: %.3f%%\n", calculate_percent_difference(Hm0, H_s))
fprintf("Average wave period difference:     %.3f%%\n", calculate_percent_difference(Tm01, T_avg))
fprintf("Significant wave period difference: %.3f%%\n\n", calculate_percent_difference(T_peak, T_s))

disp("-----------------------------------------")
disp("")

%% No-Tape HOBO Wave Analysis
% Use spectral analysis to compute Hm0, Tm01, Tm02, and peak period for the no-tape HOBO data
% Compare to wave-by-wave analysis.

% ----------Load HOBO notape data----------

[pressure_notape, eta_notape] = import_hobo_data("hobo_notape_2-26-18-2.csv");

% Notape Plotting - DEBUG
% figure(3)
% hold on
% % plot(pressure_notape);
% plot(eta_notape);
% yline(0, "--b")
% hold off
% title("No-Tape HOBO Data")
% xlabel("Time (s)")
% ylabel("Pressure (kPa) [Blue], Eta (m) [Red]")

% ----------Wave spectra analysis----------

[f, psd, Hm0, Tm01, ~, T_peak] = wave_spectra(eta_notape);

% Plotting
figure(4)
semilogy(f, psd)
title("Power Spectral Density (No-Tape)")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (m^2/Hz)")

% Display
disp("No-Tape Wave Spectra Analysis:")
fprintf("Significant wave height (Hm0): %.3f m\n", Hm0)
fprintf("Average wave period (Tm01):    %.3f s\n", Tm01)
fprintf("Average wave period (Tm02):    %.3f s\n", Tm01)
fprintf("Peak wave period:              %.3f s\n\n", T_peak)

% ----------Wave-by-wave analysis-----------

[~, H_avg, H_s, H_rms, T_avg, T_s] = wave_by_wave(eta_notape);
disp("No-Tape Wave-by-Wave Analysis:")
fprintf("Average wave height:       %.3f m\n", H_avg)
fprintf("Significant wave height:   %.3f m\n", H_s)
fprintf("RMS wave height:           %.3f m\n", H_rms)
fprintf("Average wave period:       %.3f s\n", T_avg)
fprintf("Significant wave period:   %.3f s\n\n", T_s)

% ----------Comparison----------

disp("No-Tape Analysis Comparison:")
fprintf("Significant wave height difference: %.3f%%\n", calculate_percent_difference(Hm0, H_s))
fprintf("Average wave period difference:     %.3f%%\n", calculate_percent_difference(Tm01, T_avg))
fprintf("Significant wave period difference: %.3f%%\n\n", calculate_percent_difference(T_peak, T_s))

disp("-----------------------------------------")
disp("")

%% Taped HOBO Wave Analysis
% Use spectral analysis to compute Hm0, Tm01, Tm02, and peak period for the no-tape HOBO data
% Compare to wave-by-wave analysis.

% ----------Load HOBO tape data----------

[pressure_tape, eta_tape] = import_hobo_data("hobo_tape_2_26_18.csv", 1600, 6600, 1300);

% Tape Plotting - DEBUG
% figure(3)
% hold on
% % plot(hobo_data_tape);
% plot(pressure_tape);
% plot(eta_tape);
% yline(0, "--b")
% hold off
% title("Tape HOBO Data")
% xlabel("Time (s)")
% ylabel("Pressure (kPa) [Blue], Eta (m) [Red]")

% ----------Wave spectra analysis----------

[f, psd, Hm0, Tm01, ~, T_peak] = wave_spectra(eta_notape);

% Plotting
figure(5)
semilogy(f, psd)
title("Power Spectral Density (Tape)")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (m^2/Hz)")

% Display
disp("Tape Wave Spectra Analysis:")
fprintf("Significant wave height (Hm0): %.3f m\n", Hm0)
fprintf("Average wave period (Tm01):    %.3f s\n", Tm01)
fprintf("Average wave period (Tm02):    %.3f s\n", Tm01)
fprintf("Peak wave period:              %.3f s\n\n", T_peak)

% ----------Wave-by-wave analysis-----------

[~, H_avg, H_s, H_rms, T_avg, T_s] = wave_by_wave(eta_tape);
disp("Tape Wave-by-Wave Analysis:")
fprintf("Average wave height:       %.3f m\n", H_avg)
fprintf("Significant wave height:   %.3f m\n", H_s)
fprintf("RMS wave height:           %.3f m\n", H_rms)
fprintf("Average wave period:       %.3f s\n", T_avg)
fprintf("Significant wave period:   %.3f s\n\n", T_s)

% ----------Comparison----------

disp("Tape Analysis Comparison:")
fprintf("Significant wave height difference: %.3f%%\n", calculate_percent_difference(Hm0, H_s))
fprintf("Average wave period difference:     %.3f%%\n", calculate_percent_difference(Tm01, T_avg))
fprintf("Significant wave period difference: %.3f%%\n", calculate_percent_difference(T_peak, T_s))

%% Utility
function diff = calculate_percent_difference(v1, v2)
    diff = abs(v1-v2) / ((v1+v2)/2) * 100; % Per cent
end