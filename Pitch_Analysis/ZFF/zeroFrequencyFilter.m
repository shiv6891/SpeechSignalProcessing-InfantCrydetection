        function [wav4, fs2]=zeroFrequencyFilter(sig, fs, winLength)
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

        wav1=remTrend(cwav,floor(winLength*fs/1000));
        wav2=remTrend(wav1,floor(winLength*fs/1000));
        wav3=remTrend(wav2,floor(winLength*fs/1000));
        wav4=remTrend(wav3,floor(winLength*fs/1000));
        wav4=remTrend(wav4,floor(winLength*fs/1000));
        wav4=remTrend(wav4,floor(winLength*fs/1000));
        wav4(N-1500:N) = wav4(N-1501);
	wav4 = wav4/max(abs(wav4));
