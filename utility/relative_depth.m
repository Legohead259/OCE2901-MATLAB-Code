% Determines the water depth zone the wave is within
% @param L: the wavelength of the wave in units
% @param h: the local water depth in the same units as L
% @return zone: the zone the wave is within.
%                   1 is shallow water
%                   2 is intermediate water
%                   3 is deep water
function zone = relative_depth(L, h)
    if h >= L/20
        zone = 1; % Shallow water
    elseif h >= L / 2
        zone = 3; % Deep water
    else
        zone = 2; % Intermediate water
    end
end
        