function [Hb, hb, num_iter] = break_params(H0, L0, T, Hb, hb, g, tol)
    arguments
        H0
        L0
        T
        Hb = 0;
        hb = 0;
        g = 9.81; % m/s^2
        tol = 0.001; % ± 1mm
    end
    
    if nargin == 3 % If only wave period supplied iteratively solve for wave breaking parameters
        num_iter = 0;
        y = 0;
        h = 100;
        while(abs(h-y) > tol) % Iterate through dispersion equation until tolerance is reached
            y = h; % Save previous iteration of L
            h = H0/0.8 * sqrt(L0/(4*T*sqrt(g*h)));
            h = abs((h+y) / 2); % Find average between calculations to get towards tolerance
            num_iter = num_iter + 1; % Increment number of iterations
        end
        hb = h;
        Hb = 0.8*h;
    end % Return the final L value as the theoretical wavelength