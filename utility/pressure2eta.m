% Converts a continuous pressure function into a continuous free surface
% displacement function (eta)
% @param pressure_data: the continuous pressure function in kPa
% @param rho: the density of the fluid readings were taken within in kg/m^3 (Defaults to 1025)
% @param g: local gravitational acceleration in m/s^2 (Defaults to 9.81)
% @return eta_data: the continuous free surface displacement function, eta, in meters
% @return mwl: the mean water level of the measured area in meters
function [eta_data, mwl] = pressure2eta(pressure_data, rho, g)
    arguments
        pressure_data
        rho = 1025; % kg/m^3
        g = 9.81; % m/s^2
    end
    
    % Calculate mean waterlevel
    mwl = mean(pressure_data)*1000 / (rho * g);
    
    % Detrend pressure data and convert it to free surface displacement (eta)
    eta_data = detrend(pressure_data)*1000 ./ (rho * g);
end

