% Calculate wave parameters for a wave in a specified water depth using
% multiple equations and dispersion
% @param H_0:       deepwater wave height in meters (m)
% @param T:         wave period in seconds (s)
% @param theta_0:   deep water shore angle in degrees (°)
% @param h:         design water depth in meters (m)
% @param rho:       design water density in kg/m^3 (Default: 1025)
% @param g:         gravitational acceleration in m/s^2 (Default: 9.81)

% @return L:        design wavelength in meters (m)
% @return C:        design wave celerity in meters/second (m/s)
% @return n:        design wave group modulation
% @return Cg:       design wave group celerity in meters/second (m/s)
% @return theta:    design wave shore angle in degrees (°)
% @return H:        design wave height in meters (m)
% @return F:        design wave energy flux in Joules/sq. meter (J/m^2)
function [L, C, n, Cg, theta, Ks, Kr, H, E, F] = wave_params(H0, T, h, theta0, rho, g)
    arguments
        % TODO: Argument validation
        H0
        T
        h
        theta0 = 0;    % Deg
        rho = 1025;     % kg/m^3
        g = 9.81;       % m/s^2
    end
    
    [L0, L, k0, k, ~, kh] = dispersion(T, h, g); % Calculate basic design wave parameters
    
    C = L/T;                                % Caluclate wave celerity
    n = (1/2*(1+2*kh/sinh(2*kh)));          % Calculate design group wave modulation
    Cg = n*C;                               % Calculate design group wave celerity
    theta = asind(k0/k*sind(theta0));      % Calculate design shore angle using Snell's law
    Ks = sqrt(L0/(2*T*Cg));                 % Calculate shoaling coefficient
    Kr = sqrt(cosd(theta0)/cosd(theta));   % Calculate refraction coefficient
    H = H0 * Ks * Kr;                      % Calculate design wave height
    E = 1/8 * rho * g * H^2;                % Calculate average wave energy per unit area
    F = E * Cg;                             % Calculate design energy flux
end