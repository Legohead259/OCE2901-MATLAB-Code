function [raw_data, trim_data, atmo_pressure] = import_hobo_data(filename, imperial, dataLines)
    arguments
            filename string
            imperial logical = false
            dataLines = [3, Inf]
    end

    opts = delimitedTextImportOptions("NumVariables", 9);

    % Specify range and delimiter
    opts.DataLines = dataLines;
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["Var1", "VarName2", "VarName3", "VarName4", "Var5", "Var6", "Var7", "Var8", "Var9"];
    opts.SelectedVariableNames = ["VarName2", "VarName3", "VarName4"];
    opts.VariableTypes = ["string", "datetime", "double", "double", "string", "string", "string", "string", "string"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, ["Var1", "Var5", "Var6", "Var7", "Var8", "Var9"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Var1", "Var5", "Var6", "Var7", "Var8", "Var9"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "VarName2", "TimeZone", "America/New_York", "InputFormat", "MM/dd/yy hh:mm:ss aa");

    raw_data = readtable(filename, opts); % Import the data
    if (imperial) % Check if data file is in imperial units and convert to metric
        raw_data{:, 2} = raw_data{:, 2} * 6.89476; % Convert PSI to kPa
        raw_data{:, 3} = (raw_data{:, 3} - 32) * (5/9); % Convert F to C
    end
    raw_data.Properties.VariableNames = ["Time", "Pressure", "Eta"];        % Rename table columns

    pressure_data = table2array(raw_data(:,2));                             % Pull the pressure data from the file
    threshold = 110;                                                        % kPa - where the program determines the bounds of the water pressure data begins
    w_start = find(pressure_data>threshold, 1) + 100;                       % Determine where the sensor enters the water and add 100 seconds
    w_end = find(pressure_data>threshold, 1, "last") - 100;                 % Determine where the sensor exits the water and subtract 100 seconds
    atmo_pressure = mean(pressure_data(1:w_start-190));                     % Determine atmospheric pressure from initial line of data
    pressure_data = pressure_data(w_start:w_end) - atmo_pressure;           % Trim the pressure data to acceptable range and convert to gauge pressure
    eta_data = pressure2eta(pressure_data);                                 % Convert pressure signal to surface displacement and detrend it
    trim_data = table(raw_data{w_start:w_end, 1}, pressure_data, eta_data); % Create new data table trimmed to workable range
    trim_data.Properties.VariableNames = ["Time", "Pressure", "Eta"];       % Rename table columns
end