function [Syy,f] = compute_pBT(y,maxlag,nfft,fs,lagwindow)
% [ Syy, f ] = compute_pBT( y, maxlag, nfft, fs, lagwindow )
% perform Blackman-Tukey spectral estimation to compute a power spectrum.
%   y: input signal
%   maxlag: maximum lag for autocorrelation
%   nfft: number of FFT points
%   fs: sampling frequency
%   lagwindow: type of lag window ('t', 'g', 'h', 'b')
%   Syy: power spectrum
%   f: corresponding frequencies
% --------------------------------
% Giulio Matteucci 2021

% compute autocorrelation
ryy = xcorr(y - mean(y), maxlag, 'biased');
ryy = ryy';

% select lag window
switch lagwindow
    case 't'
        % triangular
        w = triang(2 * maxlag + 1);
    case 'g'
        % gauss
        w = gauss(2 * maxlag + 1);
    case 'h'
        % hamming
        w = hamming(2 * maxlag + 1);
    case 'b'
        % blackman
        w = blackman(2 * maxlag + 1);
    otherwise
        error('Invalid lag window type');
end

% compute power spectrum via FFT
Syy = abs(fft(w .* ryy, nfft));
deltf = fs / nfft;
f = 0:deltf:(fs - deltf);