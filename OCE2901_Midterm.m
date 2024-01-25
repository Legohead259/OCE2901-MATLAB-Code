% OCE2901 - Midterm
% Braidan Duffy
% 03/23/2021

%% Import Data
l_MA = import_lowell_MA("1404107_duffy_test_(0)_MA.txt");
l_RPY = import_lowell_YRP("1404107_duffy_test_(0)_RPY.txt");
l_data = [l_MA, l_RPY(:,2:4)]; % Concatenate MA and RPY values into single table

hobo_data = import_hobo_data("duffy_test");

%% Plot Data
% Lowell
figure(1)
t = tiledlayout(3, 1);
title(t, "Lowell Midterm Data")
nexttile
plot(l_data{:,1}, l_data{:,2:4})
ylabel("Acceleration (g)")
title("Accelerometer Data")
legend("X-axis (down)", "Y-axis (left)", "Z-axis (fwd)")
nexttile
plot(l_data{:,1}, l_data{:,5:7})
ylabel("Magnetic Field Strength (mG)")
title("Magnetometer Data")
legend("X-axis (down)", "Y-axis (left)", "Z-axis (fwd)")
nexttile
plot(l_data{:,1}, l_data{:,8:10})
ylabel("Attitude (deg)")
title("Roll/Pitch/Yaw Data")
legend("Yaw", "Pitch", "Roll")

% HOBO
figure(2)
yyaxis left
plot(hobo_data{:,1}, hobo_data{:,2}) % Pressure data
ylabel("Pressure (kPa)")
yyaxis right
plot(hobo_data{:,1}, hobo_data{:,3}) % Temperature data
ylabel("Temperature (°C)")
title("HOBO Instrument Data")