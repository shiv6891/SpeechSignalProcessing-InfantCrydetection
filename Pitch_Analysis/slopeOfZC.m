function[m1,m2,p1axis,p2,y,fs] = slopeOfZC(s, fs, winLength, plotflag)

	% Pass the speech signal through zero frequency filter.
	ls = length(s);
	[zfo, fs2]=zeroFrequencyFilter(s, fs, winLength);	
	y = zfo;

        signy = sign(y);
        locZero = find(signy == 0);
        signy(locZero) = 1;

        zc=diff(signy);
        zc(length(y)) = zc(length(y)-1);

	npzcLoc=find(zc==2);
	pnzcLoc=find(zc==-2);

	%npzcLoc = npzcLoc + 1;
	%pnzcLoc = pnzcLoc + 1;

	l1 = length(npzcLoc);
	l2 = length(pnzcLoc);

	p1 = npzcLoc(2:l1-2);
	p2 = pnzcLoc(2:l2-2);

	m1 = y(p1+1) - y(p1);
	m2 = y(p2+1) - y(p2);

	p1 = round(p1*fs/fs2);
	p2 = round(p2*fs/fs2);
	
	y = resample(zfo, fs, fs2);
	y = y/1.1/max(abs(y));
    p1axis = p1/fs;
	if plotflag==1
	
	figure;

        subplot(4,1,1);plot([1:length(s)]/fs,  s/1.1/max(abs(s)),'k');grid;
        xlim([1/fs length(y)/fs]);
        ylim([-1 1]);

        subplot(4,1,2);plot([1:length(y)]/fs, y/1.1/max(abs(y)),'k');grid;
        xlim([1/fs length(y)/fs]);
        ylim([-1 1]);

        subplot(4,1,3);plot(p1/fs, m1,'k.');grid;
        xlim([1/fs length(y)/fs]);
        ylim([-1 1]);

        subplot(4,1,4);plot(p2/fs, m2,'k.');grid;
        xlim([1/fs length(y)/fs]);

	end
