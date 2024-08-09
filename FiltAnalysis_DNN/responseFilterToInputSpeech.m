close all, clear
%LP residual
%filename = 'S45_M_08m_sn2_c01_09_Anxt.wav';
%% Filepath assignments
% ZFF files
%filename = '/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/ZFFOutput2/noSil/preProc2/Pain/S01_F_02d_sn1_c01_09_Pain_1.wav';
%filename = '/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/ZFFOutput2/noSil/preProc2/Pain/S06_M_24m_sn1_c01_23_Pain_1.wav';
% Wav files
filename = '/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/wav2/noSil/preProc2/Pain/S01_F_02d_sn1_c01_09_Pain_1.wav';
%filename = '/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/wav2/noSil/preProc2/Pain/S06_M_24m_sn1_c01_23_Pain_1.wav';
%% Compute response and LP spectrum code
idx_frame = 750;
[freq,response]=computeResponse(filename,idx_frame);

figure
plot(freq,response,'-','LineWidth',1)
xlabel('frequency (Hz)')
ylabel('S_t')

% N=4096;
% lp_order = 16;
% [freq,lpspectrum]=lpSpectrum(filename,idx_frame, lp_order,1,N);
% 
% figure
% plot(freq,lpspectrum,'-','LineWidth',1)
% xlabel('frequency (Hz)')
% ylabel('LP spectrum')



function [freq,finalRes] = computeResponse(filename, idx)

[data,fs] = audioread(filename);
data=(data-mean(data))/std(data);
wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/13Jan_Layers_Inputs_All/Cry/2Layers_Cry/best_mdlwts_CV1.txt')';
%wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/kf_nnetcry/exp/saved_files/conv1wts_CV_RawCry1_nnetCry.txt');

%split data
shift=160;
dW=8;
kW=size(wts,2);
context=1;
len=shift*(2*context+1);
N=4096;
freq=(0:N/2)*(fs/N);
finalRes=0;
nbPoints=floor((len-kW)/dW)+1;
nbFrames=floor((size(data,1))/shift);
nbFilters=size(wts,1);
countFrames=0;
%Average over all frames
for i=idx:idx%1:nbFrames %idx:idx
    idx0=(i-1)*shift+1;
    idx1=idx0+(2*context+1)*shift-1;
    if (idx0>=1) && (idx1<=size(data,1))
        frame=data(idx0:idx1);
%         figure; plot(frame);
        %compute convolution over frame i
        for j=1:nbPoints
            temp=frame((j-1)*dW+1:(j-1)*dW+kW);
            res = 0;
            %sum over filters
            for k=1:nbFilters
                o=wts(k,:)*temp;
                f = fft(wts(k,:),N);
                f=f(1:N/2+1);
                res=res+o*f;
            end
            res=abs(res);
            res=res/sum(res);
            finalRes=finalRes+res;
            countFrames=countFrames+1;
        end
    end
end
finalRes=finalRes/countFrames;
%finalRes=finalRes/sum(finalRes);

end

function [freq,lpspec] = lpSpectrum(filename, idx, lporder, win, order)

% this routine computes the linear prediction coefficients and plots
% the lp specturm in the figure with number fignu and plottitle as the
% title, along with the fourier spectrum. The usage is as given below
%
% lpspec = lpSpectrum(data, lporder, win, order, sf, fignu, 'plottitle');
%
% where data is the short-time signal, lporder is the order of the linear
% predicition, win is 0 for rectangular window and 1 for Hamming window.
% order is the FFT order used during the computation of lp spectrum,
% sf is the sampling frequency the computed lp spectrum is plotted in 
% figure fignu with plottitle as the title.

[data,fs] = audioread(filename);
context = 1;
shift = 160;
%data = data(idx*160+1:idx*160+(2*context+1)*160);
data = data((idx-1)*shift+1:(idx-1)*shift+(2*context+1)*shift);
if win == 1
 data = data .* hamming(length(data));
end

% preemphasize to remove the spectral tilt due to glottal pulse spectrum.
difdata(1) = data(1);
difdata(2:length(data)) = diff(data);
if size(difdata, 2)>1
   difdata = difdata';
end

for n=1:order freq(n) = ((n-1) * fs)/(order); end

% Computation of lp Spectrum
a = lpc(difdata, lporder);
%lpspec = 1./abs(fft(a, order));
lpspec = -20 * log10(abs(fft(a, order)));
freq = freq(1:(order/2)+1);
lpspec = lpspec(1:(order/2)+1);

end
