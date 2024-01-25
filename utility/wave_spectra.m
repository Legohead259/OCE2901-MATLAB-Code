% Calculates various wave parameters through the power spectra density of
% the continuous surface displacement function, eta.
% @param eta: the continuous free surface displacement function
% @param fs: the sampling frequency of the data in Hertz (Defaults to 1 Hz)
% return f: a vector of frequencies for plotting purposes
% @return psd_eta_1sided: the PSD function of Eta for plotting
% @return Hm0: the significant wave height determined from the PSD function in the units of Eta
% @return Tm01: the average wave period determined by the PSD function in seconds
% @return Tm02: the average wave period determined by the PSD function in seconds
% @return T_peak: the peak period of Eta in seconds
% @return f_peak: the peak frequency of Eta in seconds
function [f, psd_eta_1sided, Hm0, Tm01, Tm02, T_peak, f_peak] = wave_spectra(eta, fs)
    arguments
        eta
        fs = 1
    end
    
    % Filter eta to nice power of 2
    eta = eta(1:pow2(floor(log2(numel(eta)))));
    
    % Generating frequency vector
    N = length(eta); % Length of frequency vector
    df = fs/N; % Frequency difference between samples
    f = 0:df:fs/2; % Generate frequency vector from 0 Hz to f_nyq

    % Begin spectral analysis
    etaFFT = fft(eta)'; % Convert eta from time space to frequency space
    etaFFT = etaFFT(1:length(f)); % Trim fft data to length of frequnecy vector
    psd_eta_2sided = (1/(N*fs))*(abs(etaFFT)).^2; % m^2/Hz - Calculate Power Spectral Density (PSD)
    psd_eta_1sided = psd_eta_2sided;
    psd_eta_1sided(2:end-1) = 2.*psd_eta_1sided(2:end-1); % Fold over 1 sided PSD
    
    % TODO: Generate figure plot of peaks? If no output arguments are
    % given?
    
    % Calculate wave characteristics
    m0 = sum(psd_eta_1sided .* f.^0 .* df); % zero-moment of PSD
    m1 = sum(psd_eta_1sided .* f.^1 .* df); % first-moment of PSD
    m2 = sum(psd_eta_1sided .* f.^2 .* df); % second-moment of PSD
    Hm0 = 4 * sqrt(m0); % zero-moment wave height
    [~, max_idx] = max(psd_eta_1sided);
    f_peak = f(max_idx);    % Hz - Peak frequency
    T_peak = 1/f_peak;      % s - Peak period
    Tm01 = m0/m1;           % s - mean period
    Tm02 = (m0/m2)^0.5;     % s - zero-crossing period
end

