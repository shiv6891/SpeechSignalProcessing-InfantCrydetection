function [forms, xaxis] = winForm(sig, fs, order, fsize, fshift, pflag, dflag)
% Returns: 5XFrames dimensional matrix of Formant values
N = 1024;                                                                   %   FFT Points
N_2 = ceil(N/2); 
bin_vals = [0 : N-1];
freq = bin_vals*fs/N;
% Convert from milliseconds to samples
S = floor(fsize*fs/1000);
L = floor(fshift*fs/1000);
P=S-L;
optP = sig(1:P);
y = sig(P+1:end);
% Preemphasize the signal and Arrange speech into blocks.
if (dflag == 1)
    s = diff(y);
    s(length(y)) = s(end);
    bufs = buffer(s,S,P,optP);
    bsig = s;                                                               %   Just to plot the updated signal
else
    bufs = buffer(y,S,N-L,optP);
    bsig = y;
end
D = size(bufs);
c = D(2);
xaxis = [floor(N/2):L:floor(N/2) + (c-1)*L + 2]/fs; % In seconds.
forms = nan(5, c);
% Compute autocorrelation for each block.
for i=1:c    
    [a,g]=lpc(bufs(:,i),order);
    [lspec, lpfr] = freqz(g,a,freq,fs);
    lpLogsp = 20*log10(abs(lspec));
%     if (pflag ==1)
%         bx(2) = subplot(4,1,2);
%         plot(freq, lpLogsp,'k');
%         % xlim([0 6000]);
%         % axis tight;
%         title('Smoothed Spectral Envelope and Magnitude Spectrum (Fs: 10 KHz, LP Order: 12)');
%     end
%     hold on
    % Get the peaks from the smoothed signal
        y1 = [diff(lpLogsp) > 0]; 	% Positive y1 indicates increasing trend.
        y2 = [diff(lpLogsp) <= 0];	% Positive y2 indicates decreasing trend.

	% Identify 1-0 transitions in y1, or identify 0-1 transition in y2.
        [locPeaks] = find((y1(1:length(y1)-1) + y2(2:length(y2))) == 2);
        if isempty(locPeaks) == 0
            locPeaks = locPeaks(:) + ones(length(locPeaks),1);
        end
        if (isempty(locPeaks))
            continue
        end
        peakVal = lpLogsp(locPeaks);
        forPeakIn = locPeaks(1:min(length(locPeaks), 5));                                          %   Change to desired number (n) for the fist n peaks
        forPeakVal = peakVal(1:length(forPeakIn));
        forms(1:length(forPeakIn), i) = lpfr(forPeakIn);
%         if (plotFlag ==1)    
%             bx(3) = subplot(4,1,2);
%             plot(forms, forPeakVal,'ro');
%             % linkaxes(ax, 'x');
%         end  
disp("frame")
i
end
end