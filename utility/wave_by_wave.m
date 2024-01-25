 % Calculates several wave characteristics based on passed surface displacement data (eta).
% NOTE: This data should be as santized and clean as possible before being
% passed to this function. It will not do any sanitization beforehand
% This function works by breaking the wave data into distinct waves via the
% zero upcrossing method. THis method delimits waves by where the data
% transitions from a negative value to a positive value.

% @param eta: the eta function to be processed in meters (m)
% @param freq: the sampling frequency of the data in Hertz (Defaults to 1)
% @param g: gravitational acceleration in meters per second^2 (m/s^2) (Defaults to 9.81)
% @param alpha: the beach slop in degrees (Defaults to 5°)
% @return delims: an array of indexes where the eta data is delimitted to individual waves
% @return H_avg: the average wave height from the data in units
% @return H_highthird: an array of the highest 1/3 of wave heights in units
% @return H_rms: the RMS of the wave height data in units
% @return T_avg: the average period from the data in seconds
% @return T_highthird: the period of the heighest 1/3 of waves in seconds
% @return Ir: a vector of Iribarren numbers corresponding to the waves detected by the algorithm
function [delims, H_avg, H_highthird, H_rms, T_avg, T_highthird, waves] = wave_by_wave(eta, freq, g, alpha)
    arguments
        eta;
        freq = 1;
        g = 9.81;
        alpha = 1.25; % Paradise Beach, Fl is about 1.25° of slope
    end
    
    % Determine wave deliminations via to upcross method (data goes from neg to positive)
    index = 1; % instantiate upcrosses index
    
    neg_data_locs = find(eta < 0); % Generate index array of negative data values
    for i=1:length(neg_data_locs)
        try
            if eta(neg_data_locs(i)+1) >= 0 % Identify locations of up-crossings
%                 disp("Found an upcross!") % DEBUG
                delims(index) = neg_data_locs(i);
                index = index + 1;
            end
        catch
            continue
        end
    end
        
    % Create an array of wave structs to work with
    for i=1:length(delims)-1
        waves(i).delim = delims(i);
        waves(i).values = eta(delims(i):delims(i+1));                  % Determine data for specific wave between delimitters
        waves(i).height = max(waves(i).values) - min(waves(i).values);  % Determine wave height as the trough+crest
        waves(i).period = (delims(i+1) - delims(i)) / freq;             % Determine the wave period by distance between up-crossings
        waves(i).L0 = g/(2*pi) * waves(i).period^2;                     % Determine the deep water wavelength
        waves(i).Ir = tand(alpha) / sqrt(waves(i).height / waves(i).L0);      % Determine Iribarren number (Ir) and append to output vector
    end
        
    % Calculate height data
    Heights = [waves(1:end).height];                            % Create array of heights from struct array
    H_avg = mean(Heights);                                      % Find average wave heights
    [Heights, Idx] = sort(Heights, "descend");                  % Sort wave heights from largest-smallest
    H_highthird = mean(Heights(1:fix(numel(Heights)/2)));       % Determine average of top 1/3 of wave heights
    H_rms = rms(Heights);                                       % Find RMS of wave heights

    % Calculate period data
    T_avg = mean([waves(1:end).period]);                            % Determine average period from the struct array
    T_highthird = mean([waves(Idx(1:fix(numel(Idx)/3))).period]);   % Determine the average period of the high 1/3 of waves
end