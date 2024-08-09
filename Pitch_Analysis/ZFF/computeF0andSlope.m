function [if0,it0,slope,it] = computeF0andSlope(zfs, fs2, plotflag)
    
    
	s = zfs;

	signs = sign(s);
	locZero = find(signs == 0);
	signs(locZero) = 1;
	
        zc=diff(signs);
        zc(length(s)) = zc(length(s)-1);

        pzc = zc == 2;
        nzc = zc == -2;

        pzcloc = find(zc==2);
        nzcloc = find(zc==-2);

        p = pzcloc(2:end-2);
        n = nzcloc(2:end-2);

        i1 = p-2;
        i2 = p+2;
	mpos = (s(i2) - s(i1))/4;
        mp = abs(mean(mpos));

        j1 = n-2;
        j2 = n+2;
	mneg = (s(j2) - s(j1))/4;
        mn = abs(mean(mneg));

        if mp > mn
		xloc = p;
		slope = abs(mpos);
        else
		xloc = n;
		slope = abs(mneg);
        end

	slope; % Slope of ZC.

	it = xloc/fs2; % Time index in seconds.
	it0 = diff(xloc)*1000/fs2; % Pitch period in milliseconds.

	lx = length(it0);
	it0(lx+1) = it0(lx);
	%it0 = medfilt1(it0,3);
	if0 = 1000*repmat(1,length(it0),1)./it0(:); % Instantaneous f0 in Hz.

% Uncomment for thresholding
% 	0.000003000


% 	m = slope/max(slope);
%     if(min(m)<0.000004)
%         threshold = 000003;
%     else
%         threshold = 0.1;
%     end
% 	vloc = find(m > threshold);
% 	
% 	tmp = slope(vloc);
% 	clear slope;
% 	slope = tmp;
% 	clear tmp;
% 	
% 	tmp = it(vloc);
% 	clear it;
% 	it = tmp;
% 	clear tmp;
% 
% 	tmp = it0(vloc);
% 	clear it0;
% 	it0 = tmp;
% 	clear tmp;
% 	
% 	tmp = if0(vloc);
% 	clear if0;
% 	if0 = tmp;
% 	clear tmp;


	% Refer to f0ZCofFilteredSignal.m in
	% /home/instant/guru/matcode/pitchInDistantSpeech/zfrSigzfrHeCloseSpeech
	% for changing from instantaneous to once-in-10-ms format.
