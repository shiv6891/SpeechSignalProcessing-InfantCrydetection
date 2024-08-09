function[m1,m2,p1axis,p2,y] = gci(zfo, fs, fs2)


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