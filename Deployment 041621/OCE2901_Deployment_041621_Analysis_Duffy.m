% OCE2901 - Deployment 04/16/21 Analysis
% Braidan Duffy
% 04/22/21

close all; clear all;

%% Import Deployment Data
% Import Lowell Data
l1_MA = import_lowell_MA("2103022_SEA_4_16_21_1_(0)_AccelMag.csv");
l1_RPY = import_lowell_YRP("2103022_SEA_4_16_21_1_(0)_YawPitchRoll.csv");
l1_data = [l1_MA l1_RPY(:, 2:4)]; % Concatenate MA and RPY data into single table
l1_data.Properties.VariableNames([9,10]) = {'RollDegrees', 'PitchDegrees'}; % Switch Lowell roll/pitch to board roll/pitch

l2_MA = import_lowell_MA("2103023_SEA_4_16_21_2_(0)_AccelMag.csv");
l2_RPY = import_lowell_YRP("2103023_SEA_4_16_21_2_(0)_YawPitchRoll.csv");
l2_data = [l2_MA l2_RPY(:, 2:4)]; % Concatenate MA and RPY data into single table
l1_data.Properties.VariableNames([9,10]) = {'RollDegrees', 'PitchDegrees'}; % Switch Lowell roll/pitch to board roll/pitch

% Import iPhone data
iData = import_iphone_sensorlog("SEA_1_2021-04-16_08-00-52_-0400.csv");

% Import HOBO data
[fs_raw, fs_trim, atmo_pressure] = import_hobo_data("FieldDeployment_041621_Farshore.csv", true);

[ns_raw, ns_trim] = import_hobo_data("FieldDeployment_041621_Nearshore.csv", true);

%% Plot Raw Data
% Lowell 1
figure
t = tiledlayout(2,1);
title(t, "Lowell 1 Data - April 16, 2021")
nexttile
plot(l1_data{:,1}, l1_data{:, 2:4}) % Plot XYZ accelerations from Lowell 1
title("XYZ Acceleration")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(l1_data{:,1}, l1_data{:,8:10}) % Plot roll, pitch, and yaw from Lowell 1
title("Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Yaw", "Roll", "Pitch")

% Lowell 2
figure
t = tiledlayout(2,1);
title(t, "Lowell 2 Data - April 16, 2021")
nexttile
plot(l2_data{:,1}, l2_data{:, 2:4}) % Plot XYZ accelerations from Lowell 2
title("XYZ Acceleration")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(l2_data{:,1}, l2_data{:,8:10}) % Plot roll, pitch, and yaw from Lowell 2
title("Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Yaw", "Roll", "Pitch")

% iPhone Data
figure
t = tiledlayout(3, 1);
title(t, "iPhone SensorLog data - April 16, 2021")
nexttile
plot(iData{:,1}, iData{:,22:24}) % Plot XYZ accelerations from the iPhone
title("XYZ Acceleration")
ylabel("Acceleration (g)")
legend("X-axis (North)", "Y-axis (East)", "Z-axis (Down)")
nexttile
plot(iData{:,1}, rad2deg(iData{:,30:32})) % Plot roll, pitch, and yaw from iPhone
title("Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Yaw", "Roll", "Pitch")
nexttile
plot(iData{:,1}, iData{:, 57}) % Plot altimeter data from iPhone
title("Relative Altitude")
ylabel("Altitude (m)")

% HOBO Farshore
figure
t = tiledlayout(3, 1);
title(t, "HOBO 2 (Farshore) Data - April 16, 2021")
nexttile
plot(fs_raw{:,1}, fs_raw{:,2})
title("Raw Pressure")
ylabel("Abs. Pressure (kPa)")
nexttile
plot(fs_trim{:,1}, fs_trim{:,2})
title("Trimmed Pressure")
ylabel("Gauge Pressure (kPa)")
nexttile
plot(fs_trim{:,1}, fs_trim{:,3})
title("Surface Displacement")
ylabel("Displacement (m)")

% HOBO Nearshore
figure
t = tiledlayout(3, 1);
title(t, "HOBO 1 (Nearshore) Data - April 16, 2021")
nexttile
plot(ns_raw{:,1}, ns_raw{:,2})
title("Raw Pressure")
ylabel("Abs. Pressure (kPa)")
nexttile
plot(ns_trim{:,1}, ns_trim{:,2})
title("Trimmed Pressure")
ylabel("Gauge Pressure (kPa)")
nexttile
plot(ns_trim{:,1}, ns_trim{:,3})
title("Surface Displacement")
ylabel("Displacement (m)")

%% Convert to Linear Accelerations
% Apply a high-pass filter and remove gravity from accelerometer signals
f_cutoff = 0.1; % Hz
f_sample = 16; % Hz
[b, a] = butter(8, f_cutoff/(f_sample/2), 'high'); % Create a butterworth filter
figure
freqz(b,a) % Display filter impact
l1_data{:, 2:4} = filtfilt(b,a,l1_data{:, 2:4}); % Filter L1 accelerometer data
l2_data{:, 2:4} = filtfilt(b,a,l2_data{:, 2:4}); % Filter L2 accelerometer data
iData{:, 22:24} = filtfilt(b,a,iData{:, 22:24}); % Filter iPhone accelerometer data

% Plot filtered accelerometer signals
figure
t = tiledlayout(3,1);
title(t, "Lowell and iPhone Accelerometer Data with Highpass (Gravity) Filter")
nexttile
plot(l1_data{:,1}, l1_data{:, 2:4}) % Plot Lowell 1 XYZ accelerations
title("Lowell 1")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(l2_data{:,1}, l2_data{:, 2:4}) % Plot Lowell 2 XYZ accelerations
title("Lowell 2")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(iData{:,1}, iData{:, 22:24}) % Plot iPhone XYZ accelerations
title("iPhone")
ylabel("Acceleration (g)")
legend("X-axis (North)", "Y-axis (East)", "Z-axis (Up)")

%% Analyze Target Time

% Input target time desired for analysis
target_time = "2021-04-16 09:05:21";
duration = 12; % s
target_start = datetime(target_time, "TimeZone", "America/New_York", "InputFormat", "yyyy-MM-dd hh:mm:ss");
target_end = target_start + seconds(duration);

l1_idx = find(isbetween(l1_data{:,1},target_start, target_end));    % Get Lowell 1 time indexes
l2_idx = find(isbetween(l2_data{:,1},target_start, target_end));    % Get Lowell 2 time indexes
iIdx = find(isbetween(iData{:,1}, target_start, target_end));       % Get iPhone time indexes
fs_idx = find(isbetween(fs_trim{:,1}, target_start, target_end));   % Get Farshore HOBO time indexes
ns_idx = find(isbetween(ns_trim{:,1}, target_start, target_end));   % Get Farshore HOBO time indexes

% Plot Lowell 1 data for target time
figure
t = tiledlayout(2,1);
title(t, "Lowell 1 Data - "+target_time)
nexttile
plot(l1_data{l1_idx,1}, l1_data{l1_idx, 2:4}) % Plot XYZ accelerations from Lowell 1
title("XYZ Acceleration")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(l1_data{l1_idx,1}, l1_data{l1_idx,8:10}) % Plot roll, pitch, and yaw from Lowell 1
title("Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Yaw", "Roll", "Pitch")

% Plot Lowell 2 data for target time
figure
t = tiledlayout(2,1);
title(t, "Lowell 2 Data - "+target_time)
nexttile
plot(l2_data{l2_idx,1}, l2_data{l2_idx, 2:4}) % Plot XYZ accelerations from Lowell 1
title("XYZ Acceleration")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(l2_data{l2_idx,1}, l2_data{l2_idx,8:10}) % Plot roll, pitch, and yaw from Lowell 1
title("Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Yaw", "Roll", "Pitch")

% Plot iPhone data for target time
figure
t = tiledlayout(3, 1);
title(t, "iPhone SensorLog data - " + target_time)
nexttile
plot(iData{iIdx,1}, iData{iIdx,22:24}) % Plot XYZ accelerations from the iPhone
title("XYZ Acceleration")
ylabel("Acceleration (g)")
legend("X-axis (North)", "Y-axis (East)", "Z-axis (Down)")
nexttile
plot(iData{iIdx,1}, rad2deg(iData{iIdx,30:32})) % Plot roll, pitch, and yaw from iPhone
title("Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Yaw", "Roll", "Pitch")
nexttile
yyaxis right
plot(iData{iIdx,1}, iData{iIdx, 58}) % Plot pressure data from iPhone on right
ylabel("Abs. Pressure (kPa)")
yyaxis left
plot(iData{iIdx,1}, iData{iIdx, 57}) % Plot altitude data from iPhone on left
title("Relative Altitude")
ylabel("Altitude (m)")
legend("Altitude", "Pressure")

% Plot HOBO data for target time
figure
t = tiledlayout(2,1);
title(t, "HOBO Surface Displacement - " + target_time)
nexttile
plot(fs_trim{fs_idx, 1}, fs_trim{fs_idx, 3}) % Plot farshore surface displacement
title("Farshore")
ylabel("Surface Displacement (m)")
nexttile
plot(ns_trim{ns_idx, 1}, ns_trim{ns_idx, 3}) % Plot nearshore surface displacement
title("Nearshore")
ylabel("Surface Displacement (m)")

%% Low-pass Filtering
% Apply low-pass butterworth filter to Lowell instruments
f_cutoff = 2.0; % Hz
f_sample = 16; % Hz
l1_filtered = l1_data(l1_idx,:); % Create working table for the L1 target data
l2_filtered = l2_data(l2_idx,:); % Create working table for the L2 target data
[b, a] = butter(8, f_cutoff/(f_sample/2)); % Create a 6th order butterworth filter for Lowell Data
% freqz(b,a)
l1_filtered{:, 2:10} = filtfilt(b,a,l1_filtered{:, 2:10}); % Filter L1 target data
l2_filtered{:, 2:10} = filtfilt(b,a,l2_filtered{:, 2:10}); % Filter L2 target data

% Apply low-pass butterworth filter to iPhone
iFiltered = iData(iIdx,:); % Create working table for the iPhone target accelerometer data
[b, a] = butter(7, f_cutoff/(f_sample/2)); % Create a butterworth filter for iPhone data
% freqz(b, a) % Display impact 
iFiltered{:,22:24} = filtfilt(b, a, iFiltered{:,22:24}); % Filter target iPhone data
iFiltered{:,30:32} = filtfilt(b, a, iFiltered{:,30:32}); % Filter target iPhone data

% Plot raw and filtered data for Lowell 1
figure
t = tiledlayout(2,2);
title(t, "Filtered and Raw Data for Lowell 1 - "+target_time)
nexttile
plot(l1_filtered{:,1}, l1_filtered{:,2:4}) % plot filtered XYZ acceleration
title("Filtered Acceleration XYZ")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(l1_filtered{:,1}, l1_filtered{:,8:10}) % plot filtered Roll/Pitch/Yaw
title("Filtered Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Yaw", "Roll", "Pitch")
nexttile
plot(l1_filtered{:,1}, l1_data{l1_idx,2:4}) % plot raw XYZ acceleration
title("Raw Acceleration XYZ")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(l1_filtered{:,1}, l1_data{l1_idx,8:10}) % plot raw Roll/Pitch/Yaw
title("Raw Roll/Pitch/Yaw")
ylabel("Acceleration (g)")
legend("Yaw", "Roll", "Pitch")

% Plot raw and filtered data for Lowell 2
figure
t = tiledlayout(2,2);
title(t, "Filtered and Raw Data for Lowell 2 - "+target_time)
nexttile
plot(l2_filtered{:,1}, l2_filtered{:,2:4}) % plot filtered XYZ acceleration
title("Filtered Acceleration XYZ")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(l2_filtered{:,1}, l2_filtered{:,8:10}) % plot filtered Roll/Pitch/Yaw
title("Filtered Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Yaw", "Roll", "Pitch")
nexttile
plot(l2_filtered{:,1}, l2_data{l2_idx,2:4}) % plot raw XYZ acceleration
title("Raw Acceleration XYZ")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(l2_filtered{:,1}, l2_data{l2_idx,8:10}) % plot raw Roll/Pitch/Yaw
title("Raw Roll/Pitch/Yaw")
ylabel("Acceleration (g)")
legend("Yaw", "Roll", "Pitch")

% Plot raw versus filtered iPhone data
figure
t = tiledlayout(2,2);
title(t, "Filtered and Raw Data for iPhone - "+target_time)
nexttile
plot(iFiltered{:,1}, iFiltered{:,22:24}) % plot filtered XYZ acceleration
title("Filtered Acceleration XYZ")
ylabel("Acceleration (g)")
legend("X-axis (North)", "Y-axis (East)", "Z-axis (Up)")
nexttile
plot(iFiltered{:,1}, deg2rad(iFiltered{:,30:32})) % plot filtered Roll/Pitch/Yaw
title("Filtered Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Yaw", "Roll", "Pitch")
nexttile
plot(iFiltered{:,1}, iData{iIdx,22:24}) % plot raw XYZ acceleration
title("Raw Acceleration XYZ")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (port)", "Z-axis (fwd)")
nexttile
plot(iFiltered{:,1}, deg2rad(iData{iIdx,30:32})) % plot raw Roll/Pitch/Yaw
title("Raw Roll/Pitch/Yaw")
ylabel("Acceleration (g)")
legend("Yaw", "Roll", "Pitch")

%% Convert to UCS (North-East-Down)

%% Determine and Plot Board Velocity

%% Determine and Plot board Displacement