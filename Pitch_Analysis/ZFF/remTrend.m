        function [out]=remTrend(sig,winSize)

        %window=ones(winSize,1)/winSize;
        window=ones(winSize,1);
        tmp=conv(sig,window);
        rm=tmp(floor(winSize/2):length(sig)+floor(winSize/2)-1);

        tmp=conv(ones(length(sig),1),window);
        norm=tmp(floor(winSize/2):length(sig)+floor(winSize/2)-1);
        rm=rm(:)./norm(:);

        out=sig(:)-rm(:);
