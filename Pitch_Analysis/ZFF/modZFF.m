        function [wav6, fs2]=modZFF(sig, fs, winLength)
        wav = sig;

        if(fs<32000)
                wav=resample(wav,32000,fs);
                fs=32000;
        end
        fs2 = fs;

        wav=(wav-mean(wav));
        dwav=diff(wav);
        dwav(length(wav)) = dwav(length(wav)-1);
        dwav=dwav/max(abs(dwav));
        N=length(dwav);

        %cwav = cumsum(cumsum(cumsum(cumsum(cumsum(cumsum(dwav))))));
        cwav = cumsum(cumsum(cumsum(cumsum(dwav))));
        %cwav = cumsum(cumsum(dwav));

        wav1=remTrend(cwav,floor(2*fs/1000));
        wav2=remTrend(wav1,floor(2*fs/1000));
        wav3=remTrend(wav2,floor(2*fs/1000));
        wav4=remTrend(wav3,floor(2*fs/1000));
        wav5=remTrend(wav4,floor(2*fs/1000));
        wav6=remTrend(wav5,floor(1*fs/1000));        
        wav6(N-1500:N) = wav6(N-1501);
	wav6 = wav6/max(abs(wav6));
% max(winLength-2, 1)