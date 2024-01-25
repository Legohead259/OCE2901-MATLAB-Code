% OCE2901 - Wave-By-Wave Data Analysis Assignment
% Braidan Duffy
% 03/03/21

% Constants
rho_sw = 1025;  % kg/m^3
g = 9.81;       % m/s^2

%% Sine Wave Analysis
% create a sine wave with amplitude of 1 sec and period of 10 seconds.   
% Create a wave analysis code using the information in the book as a guide. 
% Use the wave-by-wave analysis code to compute the average H, H1/3, Hrms, average T, and T associated with H 1/3

A = 1; % m
T = 10; % s
dx = 0.001; % Interval between samples

x_values = 0:dx:2*pi;
sine_wave = A * sin(T * x_values);
[delims, H_avg, H_highthird, H_rms, T_avg, T_highthird] = wave_by_wave(sine_wave, 1/dx);

% Display
disp("Sine Wave Analysis:");
fprintf("Average wave height:       %.3f m\n", H_avg)
fprintf("Highest 1/3 wave heights:  %.3f m\n", H_highthird)
fprintf("RMS wave height:           %.3f m\n", H_rms)
fprintf("Average wave period:       %.3f s\n", T_avg)
fprintf("Highest 1/3 wave periods:  %.3f s\n\n", T_highthird)

% Plotting - DEBUG
figure(1)
plot(x_values, sine_wave, "-k")
yline(0, "--b")
for i=1:length(delims)
    xline(delims(i)*dx, "-.r")
end
title("Sine Wave Data")
xlabel("Time (s)")
ylabel("Eta (m)")


%% No-Tape HOBO Data Analysis
% Perform the same calculations as done above, except use a real water 
% pressure time series instead of a sine wave.

extraneous_vars = ["Var1", "Var2", "Var5", "Var6", "Var7", "Var8", "Var8", "Var9"];

% Load HOBO notape data
notape_start = 1400;                                                            % Define where the good HOBO data starts
notape_end = 6700;                                                              % Define where the good HOBO data ends
hobo_table_notape = readtable("hobo_notape_2-26-18-2.csv", "HeaderLines", 2);   % Load the HOBO data and ignore the two header rows
hobo_table_notape = removevars(hobo_table_notape, extraneous_vars);             % remove the extraneous variable columns from the data
hobo_data_notape = table2array(hobo_table_notape);                              % Convert the HOBO data table into a Nx2 matrix

% Trim the HOBO data to relevant values determined from plot and subtract
% atmospheric pressure
press_data_notape = hobo_data_notape(notape_start:notape_end) - mean(hobo_data_notape(1:1300));
eta_data_notape = pressure2eta(press_data_notape); % Convert pressure data to eta function

% Calculate notape wave characteristics
[delims, H_avg, H_highthird, H_rms, T_avg, T_highthird] = wave_by_wave(eta_data_notape);

% Display notape data
disp("No-Tape HOBO Data Analysis:");
fprintf("Average wave height:       %.3f m\n", H_avg)
fprintf("Highest 1/3 wave heights:  %.3f m\n", H_highthird)
fprintf("RMS wave height:           %.3f m\n", H_rms)
fprintf("Average wave period:       %.3f s\n", T_avg)
fprintf("Highest 1/3 wave periods:  %.3f s\n\n", T_highthird)


% Notape Plotting - DEBUG
figure(2)
hold on
plot(press_data_notape);
plot(eta_data_notape);
yline(0, "--b")
hold off
title("No-Tape HOBO Data")
xlabel("Time (s)")
ylabel("Pressure (kPa) [Blue], Eta (m) [Red]")

%% Tape HOBO Data Analysis

% Load HOBO tape data
tape_start = 1600;                                                          % Define where the good HOBO data starts
tape_end = 6600;                                                            % Define where the good HOBO data ends
hobo_table_tape = readtable("hobo_tape_2_26_18.csv", "HeaderLines", 2);     % Load the HOBO data and ignore the two header rows
hobo_table_tape = removevars(hobo_table_tape, extraneous_vars);             % remove the extraneous variable columns from the data
hobo_data_tape = table2array(hobo_table_tape);                              % Convert the HOBO data table into a Nx2 matrix

% Trim the HOBO data to relevant values determined from plot and subtract
% atmospheric pressure
press_data_tape = hobo_data_tape(tape_start:tape_end) - mean(hobo_data_tape(1:1300));
eta_data_tape = pressure2eta(press_data_tape); % Convert pressure data to eta function

% Calculate notape wave characteristics
[delims, H_avg, H_highthird, H_rms, T_avg, T_highthird] = wave_by_wave(eta_data_tape);

% Display notape data
disp("Tape HOBO Data Analysis:");
fprintf("Average wave height:       %.3f m\n", H_avg)
fprintf("Highest 1/3 wave heights:  %.3f m\n", H_highthird)
fprintf("RMS wave height:           %.3f m\n", H_rms)
fprintf("Average wave period:       %.3f s\n", T_avg)
fprintf("Highest 1/3 wave periods:  %.3f s\n", T_highthird)

% Notape Plotting - DEBUG
figure(3)
hold on
% plot(hobo_data_tape);
plot(press_data_tape);
plot(eta_data_tape);
yline(0, "--b")
hold off
title("Tape HOBO Data")
xlabel("Time (s)")
ylabel("Pressure (kPa) [Blue], Eta (m) [Red]")