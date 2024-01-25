function data = import_iphone_sensorlog(filename, dataLines)
%IMPORTFILE Import data from a text file
%  SEA1202104160800520400 = IMPORTFILE(FILENAME) reads data from text
%  file FILENAME for the default selection.  Returns the data as a table.
%
%  SEA1202104160800520400 = IMPORTFILE(FILE, DATALINES) reads data for
%  the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  SEA1202104160800520400 = importfile("C:\Users\bduffy2018\OneDrive - Florida Institute of Technology\School\2021 Spring\OCE2901\Deployment 041621\SEA_1_2021-04-16_08-00-52_-0400.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 21-Apr-2021 23:29:03

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 62);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["loggingTimetxt", "loggingSampleN", "identifierForVendortxt", "deviceIDtxt", "locationTimestamp_since1970s", "locationLatitudeWGS84", "locationLongitudeWGS84", "locationAltitudem", "locationSpeedms", "locationCourse", "locationVerticalAccuracym", "locationHorizontalAccuracym", "locationFloorZ", "locationHeadingTimestamp_since1970s", "locationHeadingXT", "locationHeadingYT", "locationHeadingZT", "locationTrueHeading", "locationMagneticHeading", "locationHeadingAccuracy", "accelerometerTimestamp_sinceReboots", "accelerometerAccelerationXG", "accelerometerAccelerationYG", "accelerometerAccelerationZG", "gyroTimestamp_sinceReboots", "gyroRotationXrads", "gyroRotationYrads", "gyroRotationZrads", "motionTimestamp_sinceReboots", "motionYawrad", "motionRollrad", "motionPitchrad", "motionRotationRateXrads", "motionRotationRateYrads", "motionRotationRateZrads", "motionUserAccelerationXG", "motionUserAccelerationYG", "motionUserAccelerationZG", "motionAttitudeReferenceFrametxt", "motionQuaternionXR", "motionQuaternionYR", "motionQuaternionZR", "motionQuaternionWR", "motionGravityXG", "motionGravityYG", "motionGravityZG", "motionMagneticFieldXT", "motionMagneticFieldYT", "motionMagneticFieldZT", "motionMagneticFieldCalibrationAccuracyZ", "activityTimestamp_sinceReboots", "activitytxt", "activityActivityConfidenceZ", "activityActivityStartDatetxt", "altimeterTimestamp_sinceReboots", "altimeterResetbool", "altimeterRelativeAltitudem", "altimeterPressurekPa", "IP_en0txt", "IP_pdp_ip0txt", "deviceOrientationZ", "stateN"];
opts.VariableTypes = ["datetime", "double", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical", "double", "categorical", "double", "double", "double", "double", "categorical", "categorical", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Specify variable properties
opts = setvaropts(opts, ["identifierForVendortxt", "deviceIDtxt"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["identifierForVendortxt", "deviceIDtxt", "motionAttitudeReferenceFrametxt", "activitytxt", "activityActivityStartDatetxt", "IP_en0txt", "IP_pdp_ip0txt"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "loggingTimetxt", "TimeZone", "America/New_York", "InputFormat", "uuuu-MM-dd hh:mm:ss.SSS Z");

% Import the data
data = readtable(filename, opts);
end