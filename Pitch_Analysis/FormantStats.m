% Reads the wavs and gets the Formant summaries
% Just taking the stats for now
% --------------------------------------------------------------------------
% Reading a wav file of cry sounds and get the basic statistics by performing VAD on it
% --------------------------------------------------------------------------
% Following parameters are calculated:
% 1. cryMeanForm
% 2. cryDevForm
% 3. caseMeanForm
% 4. caseDevForm 
% 5. NDevForm: Normalised Formant Deviation = Std Dev/Mean
% 6. formv, xaxis: Formants for each fracme (as per the VAD) and time axis (frames) values
% 7. begP and endP: Cry boundaries
% 8. formDiff = Differences betweeen successive formants
% --------------------------------------------------------------------------
function [cryMeanForm, cryDevForm, caseMeanForm, caseFormDiff, caseMeanDevForm, NDevForm, form1v, xaxis1, begP, endP] = FormantStats(cryFile)

fileName = strtrim(cryFile);
[x, fs] = audioread(fileName);
p=50;
% fs2=10000;
x = x(:, 1);%Taking out the excerpts
% xr = resample(x, fs2, fs);

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
                                                            %   LP Residual
dflag = 1;
plotFlag=0;

%--------------------------------------------------------------------------
%% Formant Frequencies for a Raw Signal
[formants, xaxis1] = winForm(x,fs, p, fsize1, fshift1,plotFlag, dflag);
%--------------------------------------------------------------------------
% % Masking the Formants with the Voice Ativity Detection output
form1v = nan(size(formants));
vind = find(vas);
vind(end) = min(size(form1v, 2),vind(end));
form1v(:,vind) = formants(:, vind);

% Replace the unacceptable Form values with NANs/suitable values
% form1v(find(form1v>3000)) = nan;


%%Get the stats
%% Average and Standard Deviation of the Formants for each cry
% Get the start and end indices of the VAD regions
diffVar = diff([0; vs(1:length(form1v), 3); 0]);
% Beginning and Ending Indices of the cries
begP = find(diffVar==1);
endP = find(diffVar==-1);
endP = endP-1;
form5 = zeros(1, 5);
nonNaNFcnt = zeros(1, 5);
formdev5 = zeros(1, 5);
nonNaNFDcnt = zeros(1, 5);



% Calculate Avg and Std of the Formant frequencies (F1-F5) for all the cries
cLen = length(begP);
cryMeanForm = zeros(5, cLen);                                                %   Fundamental Parameter
cryDevForm = zeros(5, cLen);
for i = 1:cLen
    cryMeanForm(:, i) = mean(form1v(:, begP(i):endP(i)), 2);
    if sum(find(~isnan(cryMeanForm(:, i))))
        form5(find(~isnan(cryMeanForm(:, i)))) = form5(find(~isnan(cryMeanForm(:, i))))+(cryMeanForm(find(~isnan(cryMeanForm(:, i))), i))';
        nonNaNFcnt = nonNaNFcnt+(~isnan(cryMeanForm(:, i)))';
    end
    cryDevForm(:, i) = std(form1v(:, begP(i):endP(i)), 0, 2);
    if sum(find(~isnan(cryDevForm(:, i))))
        formdev5(find(~isnan(cryDevForm(:, i)))) = formdev5(find(~isnan(cryDevForm(:, i))))+(cryDevForm(find(~isnan(cryDevForm(:, i))), i))';
        nonNaNFDcnt = nonNaNFDcnt+(~isnan(cryDevForm(:, i)))';
    end
end

% Calculate the sample Mean

caseMeanForm = form5./nonNaNFcnt;
caseFormDiff = diff(caseMeanForm);
caseMeanDevForm =  formdev5./nonNaNFDcnt;
NDevForm = caseMeanDevForm./caseMeanForm;
end





