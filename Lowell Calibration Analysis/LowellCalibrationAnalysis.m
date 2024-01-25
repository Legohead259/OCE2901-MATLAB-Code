% Accelerometer and Magnetometer Fusion Test
% Braidan Duffy
% 04/01/2021

close all; clc; clear all;
addpath("C:\Users\bduffy2018\OneDrive - Florida Institute of Technology\School\2021 Spring\OCE2901\utility")

%% Import Lowell Data
% MA = import_lowell_MA("1404104_YawCal_040521_MA.txt");
% RPY = import_lowell_YRP("1404104_YawCal_040521_RPY.txt");
% MA = import_lowell_MA("1404104_YawCal_040521_MA.txt");
% RPY = import_lowell_YRP("1404104_YawCal_040521_RPY.txt", 'RPY');

MA = import_lowell_MA("2103022/2103022_PitchCal_040921_(0)_AccelMag.csv");
RPY = import_lowell_YRP("2103022/2103022_PitchCal_040921_(0)_YawPitchRoll.csv");
MARPY = [MA RPY(:, 2:4)]; % Concatenate MA and RPY data into single table

% TODO: Apply yaw rotation correction, magnetic declination correction

figure
t = tiledlayout(2,1);
title(t, "Lowell 2 Data")
nexttile
plot(MARPY.Time, [MARPY.Ax, MARPY.Ay, MARPY.Az])
title("XYZ Acceleration")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (stbd)", "Z-axis (fwd)")
nexttile
plot(MARPY.Time, [MARPY.Roll, MARPY.Pitch, MARPY.Yaw]) % Plot roll, pitch, and yaw from Lowell 1
title("Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Roll", "Pitch", "Yaw")

%% Filter Data
% Design butterworth filter
fs = 16;    % Hz - sample frequency
fc = 2.0;   % Hz - cutoff frequency
[b, a] = butter(8, fc/(fs/2), 'low'); % Generate filter

% Generate filtered data table
% Acceleration filtering
MARPY.Ax = filtfilt(b, a, MARPY.Ax);
MARPY.Ay = filtfilt(b, a, MARPY.Ay);
MARPY.Az = filtfilt(b, a, MARPY.Az);
% Magnetometer filtering
MARPY.Mx = filtfilt(b, a, MARPY.Mx);
MARPY.My = filtfilt(b, a, MARPY.My);
MARPY.Mz = filtfilt(b, a, MARPY.Mz);
% Roll/Pitch/Yaw filter
MARPY.Roll = filtfilt(b, a, MARPY.Roll);
MARPY.Pitch = filtfilt(b, a, MARPY.Pitch);
MARPY.Yaw = filtfilt(b, a, MARPY.Yaw);

% Apply Roll/Pitch/Yaw clamping
MARPY.Roll(MARPY.Roll>180)    = 180;
MARPY.Roll(MARPY.Roll<-180)   = -180;
MARPY.Pitch(MARPY.Pitch>180)  = 180;
MARPY.Pitch(MARPY.Pitch<-180) = -180;
MARPY.Yaw(MARPY.Yaw>180)      = 180;
MARPY.Yaw(MARPY.Yaw<-180)     = -180;

figure
freqz(b, a)

%% Target Time Analysis
% Input target time desired for analysis
% target_time = "2021-04-01 13:10:10";
target_time = "2021-04-09 08:32:15";
duration = 75; % s
% duration = 90; % s
target_start = datetime(target_time, "TimeZone", "America/New_York", "InputFormat", "yyyy-MM-dd HH:mm:ss");
target_end = target_start + seconds(duration);

% Plot Lowell data for target time
idx = find(isbetween(MARPY.Time,target_start, target_end)); % Get window time indexes
A_inst = [MA.Ax(idx), MA.Ay(idx), MA.Az(idx)];
RPY_inst = [RPY.Roll(idx), RPY.Pitch(idx), RPY.Yaw(idx)];
Af_inst = [MARPY.Ax(idx), MARPY.Ay(idx), MARPY.Az(idx)];
RPYf_inst = [MARPY.Roll(idx), MARPY.Pitch(idx), MARPY.Yaw(idx)];

% Plot Lowell 1 data for target time
figure
t = tiledlayout(2,1);
title(t, "Lowell 2 - Yaw Calibration - Raw Data")
nexttile
plot(MARPY.Time(idx), A_inst) % Plot XYZ accelerations from Lowell 1
title("XYZ Acceleration")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (stbd)", "Z-axis (fwd)")
nexttile
plot(MARPY.Time(idx), RPY_inst) % Plot roll, pitch, and yaw from Lowell 1
title("Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Roll", "Pitch", "Yaw")

figure
t = tiledlayout(2,1);
title(t, "Lowell 2 - Yaw Calibration - Filtered Data")
nexttile
plot(MARPY.Time(idx), Af_inst) % Plot XYZ accelerations from Lowell 1
title("XYZ Acceleration")
ylabel("Acceleration (g)")
legend("X-axis (up)", "Y-axis (stbd)", "Z-axis (fwd)")
nexttile
plot(MARPY.Time(idx), RPYf_inst) % Plot roll, pitch, and yaw from Lowell 1
title("Roll/Pitch/Yaw")
ylabel("Attitude (deg)")
legend("Roll", "Pitch", "Yaw")

%% Convert to UCS Revolution Using Quaternions
viewer = HelperOrientationViewer;
% q = ecompass(Af_inst, [MARPY.Mx(idx), MARPY.My(idx), MARPY.Mz(idx)]); % Generate quaternions from filtered Acceleration and Magnetometer data
q = quaternion(RPYf_inst, 'eulerd', 'ZYX', 'frame'); % Generate quaternions from filtered Euler RPY data
q = quaternion(RPY_inst, 'eulerd', 'ZYX', 'frame'); % Generate quaternions from raw Euler RPY data
for i=1:size(idx, 1)
    viewer(q(i));
    pause(1/16 / 5); 
end

%% Rotate Acceleration Values Using Quaternions
% Rotate acceleration frame using Quaternion vector
Arot1 = rotateframe(q, Af_inst);

% Generate rotation matrix from quaternion vectors and rotate acceleration vectors
rotmat = quat2rotm(q);
Arot2 = zeros(size(Af_inst));
for i=1:size(Af_inst,1)
    Arot2(i,:) = Af_inst(i,:) * rotmat(:,:,i);
end

% Rotate acceleration vectors using Quaternion vector
qc = compact(q);
Arot3 = quatrotate(qc, Af_inst);

% Generate eulerian rotation matrix and apply to acceleration values
rotmat_e = eul2rotm(deg2rad(RPYf_inst), 'ZYX'); % Generate rotation matrix using same rotation order as quaternion data
Arot4 = zeros(size(Af_inst));
for i=1:size(Af_inst,1)
    Arot4(i,:) = Af_inst(i,:) * rotmat_e(:,:,i);
end

% Plot acceleration rotations
figure
t=tiledlayout(4,1);
title(t, "Acceleration Vector Rotation Comparisons")
nexttile
plot(MARPY.Time(idx), Arot1)
title("roateframe()")
ylabel("Acceleration (g)")
legend("E", "N", "D")
nexttile
plot(MARPY.Time(idx), Arot2)
title("quat2rotm()")
ylabel("Acceleration (g)")
legend("E", "N", "D")
nexttile
plot(MARPY.Time(idx), Arot3)
title("quatrotate()")
ylabel("Acceleration (g)")
legend("E", "N", "D")
nexttile
plot(MARPY.Time(idx), Arot4)
title("Euler rotation matrix")
ylabel("Acceleration (g)")
legend("E", "N", "D")

%% Create Velocity Plots
% Use cumulative integration
% Vrot = cumtrapz(datenum(MARPY.Time(idx)), Arot4);
% 
% figure
% plot(MARPY.Time(idx), Vrot)
% title("Lowell 2 - Velocity (UCS)")
% ylabel("Velocity (m/s)")
% legend("X (North)", "Y (East)", "Z (Down)")

%% Create Position Plots
% Use cumulative integration
% Srot = cumtrapz(datenum(MARPY.Time(idx)), Vrot);
% 
% figure
% plot(MARPY.Time(idx), Srot)
% title("Lowell 2 - Displacment (UCS)")
% ylabel("Displacment (m)")
% legend("X (North)", "Y (East)", "Z (Down)")