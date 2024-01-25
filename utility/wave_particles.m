% Calculates the particle trajectories, velocities, and pressures beneath a
% given design wave in 10 equal partitions from z=0 to z=-h.

% @param H: the design wave height in meters (m)
% @param T: the design wave period in seconds (s)
% @param h: the design water depth in meters (m)
% @param g: gravitation acceleration in meters/second (m/s) (Default: 9.81)
% @param rho: fluid density in kg/m^3 (Default: 1025)

% @return Sx: Array of maximum particle x-displacements at each water depth partition in m
% @return Sz: Array of maximum particle z-displacements at each water depth partition in m
% @return u: Array of maximum horizontal velocities at each water depth partition in m/s
% @return w: Array of maximum vertical velocities at each water depth partition in m/s
% @return Kp: Array of pressure reduction factors through the water column
% @return P: Array of pressures at each water depth partition in Pa
% @return z: Array of water depths in m
function [Sx, Sz, u, w, Kp, P, z] = wave_particles(H, T, h, g, rho)
    arguments
        % TODO: Argument validation
        H
        T
        h
        g = 9.81; % m/s^2
        rho = 1025; % kg/m^3
    end
    
    [~,~,~,k] = dispersion(T, h, g);    % Calculate wave number with dispersion equation
    sigma = 2*pi/T;                     % Calculate angular frequency
    z = linspace(0, -h, 10); % Generate 10 equal partitions through the water column
    for i=1:length(z)                                           % Iterate through each depth
        Sx(i) = -H/2 * cosh(k*(h+z(i)))/sinh(k*h);              % Calculate max x-displacement
        Sz(i) = H/2 * sinh(k*(h+z(i)))/sinh(k*h);               % Calculate max z-displacement
        u(i) = H/2 * g*k/sigma * cosh(k*(h+z(i)))/cosh(k*h);    % Calculate maximum x velocity
        w(i) = H/2 * g*k/sigma * sinh(k*(h+z(i)))/cosh(k*h);    % Calculate maximum z velocity
        Kp(i) = cosh(k*(h+z(i)))/cosh(k*h);                     % Calculate pressure response factor
        P(i) = rho*g*H/2*Kp(i) - rho*g*z(i);                    % Calculate hydro pressure
    end
end