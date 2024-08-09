function [vad, meant0, s]= vadAC(x,fs,plotflag)

% Analysis parameters.
s = diff(x);
s(length(x)) = s(end);
%s = flipud(s(:));

sz = 30; % in ms
sh = 1; % in ms.
dur = 60; % in ms.
N = floor(sz*fs/1000);
L = floor(sh*fs/1000);
minT0 = floor(2.5*fs/1000);
threshold = 0.1;
M = floor(dur/sh);
 
% For autocorrelation of speech.

bufs = buffer(s,N,N-L,'nodelay');
[r,c] = size(bufs);
for i=1:c
	ac1 = xcorr(bufs(:,i));
	%ac1 = xcorr(flipud(bufs(:,i)));
	ac = ac1(N:2*N-1)/max(ac1);
	ac(1:minT0) = 0;
        y1 = [diff(ac) > 0];
        y2 = [diff(ac) <= 0];
        [locPeaks] = find((y1(1:length(y1)-1) + y2(2:length(y2))) == 2);
        if isempty(locPeaks) == 0
		locPeaks = locPeaks(:) + ones(length(locPeaks),1);
                [acmaxval(i),pos] = max(ac(locPeaks));
		maxpos(i) = locPeaks(pos);
	else
		acmaxval(i) = 0.001;
		maxpos(i) = 1;
	end
	%subplot(2,1,1);plot(bufs(:,i));grid;
	%subplot(2,1,2);plot(ac1(N:2*N-1)/max(ac1));grid;
	%pause
	clear y1 y2 locPeaks;
end

t0 =  medfilt1(maxpos,7)*1000/fs;
acmax = resample(acmaxval, length(s), c);
t0all = resample(t0, length(s), c);

vad = [acmax >= threshold];
y = t0all(:) .* vad(:);
loc = find(y > 0);
meant0 = mean(y(loc));

%max(y(loc))
%min(y(loc))
%meant0

if plotflag == 1
figure;
xaxis = [floor(N/2):L:floor(N/2) + (c-1)*L + 2]/fs; % In seconds.

subplot(3,1,1);plot([1:length(s)]/fs, s, 'k');
hold on;
plot([1:length(s)]/fs, vad/1.1,'r' );
xlim([1/fs length(s)/fs]);
ylim([-1 1]);

subplot(3,1,2);plot(xaxis, acmaxval, 'k.');
xlim([1/fs length(s)/fs]);

subplot(3,1,3);plot(xaxis, t0,'k.');
xlim([1/fs length(s)/fs]);
ylim([0 15]);
xlabel('Time (s)');

end

