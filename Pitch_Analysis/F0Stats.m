% Reads the wavs and gets the F0 summaries
% Just taking the stats for now
% --------------------------------------------------------------------------
% Reading a wav file of cry sounds and get the basic statistics by performing VAD on it
% --------------------------------------------------------------------------
% Following parameters are calculated:
% 1. cryMeanF0
% 2. cryDevF0
% 3. caseMeanF0
% 4. caseDevF0 
% 5. NDevF0: Normalised F0 Deviation = Std Dev/Mean
% 6. f01v, xaxis: F0 and time axis (frames) values
% 7. begP and endP: Cry boundaries
% --------------------------------------------------------------------------
function [cryMeanf0, cryDevf0, caseMeanf0, caseMeanDevf0, NDevf0, f01v, xaxis1, begP, endP] = F0Stats(cryFile)

fileName = strtrim(cryFile);
[x, fs] = audioread('S44_M_09m_sn1_c04_11_Envr.wav');

% [x, fs] = audioread('S21_F_28m_sn1_c01_13_Anxt.wav');
% For MP3 versions

x = x(:, 1);%Taking out the excerpts


% Get the spectrogram

% [t, f, S] = spect(x, fs);

[vs,zo]=vadsohn(x,fs, 't');
xaxis0 = vs(:, 2);
vas= vs(:, 3);
vas = vas';

% t1 = ceil(1.94*fs);
% t2 = ceil(2.61*fs);
% N = 3*fs;+
% x = x(t1:t2);
fsize1 = 30;                                                                %   Autocorrelation
fshift1 = 10;                                                               %   Autocorrelation
fsize2 = 30;                                                                %   LP Residual
fshift2 = 10;                                                               %   LP Residual
dflag = 0;
plotFlag=0;

%--------------------------------------------------------------------------
% Pitch Extraction (Ground truth for Pitch contour) using YIN
%--------------------------------------------------------------------------
% [nframes, fsr, f0, good, best, r] = yin(x,fs);


%--------------------------------------------------------------------------
%% Autocorrelation for Raw Signal
plotFlag = 0;
% [f01, xaxis1, t01, bsig1] = autocorr_avt0_V8b(x,fs,fsize1,fshift1,plotFlag, dflag);
[f01, xaxis1] = autocorr_V8bmedFilt(x,fs,fsize1,fshift1,plotFlag, dflag);
% autocorr_V8bmedFilt
%__________________________________________________________________________
% % Masking the F0 contour with the Voice Ativity Detection output
f01v = nan(1, length(f01));
vind = find(vas);
f01v(vind) = f01(vind);

% Replace the F0 ==fs with NANs
f01v(find(f01v>3000)) = nan;


%%Get the stats
%% Average and Standard Deviation of the SSE's for each cry
% Get the start and end indices of the VAD regions
diffVar = diff([0; vs(1:length(f01v), 3); 0]);
% Beginning and Ending Indices of the cries
begP = find(diffVar==1);
endP = find(diffVar==-1);
endP = endP-1;

% Calculate Avg and Std of the F0 for all the cries
cLen = length(begP);
cryMeanf0 = zeros(1, cLen);                                                %   Fundamental Parameter
cryDevf0 = zeros(1, cLen);
for i = 1:cLen
    cryMeanf0(1, i) = mean(f01v(1, begP(i):endP(i)));
    cryDevf0(1, i) = std(f01v(1, begP(i):endP(i)));
end

% Calculate the sample Mean

caseMeanf0 = mean(cryMeanf0(~isnan(cryMeanf0)));
caseMeanDevf0 =  mean(cryDevf0(~isnan(cryDevf0)));
NDevf0 = caseMeanDevf0/caseMeanf0;
end




