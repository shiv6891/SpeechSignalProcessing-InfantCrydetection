close all; clear
%% Visualizing Cumulative response of the filters learned for a model
% wts_act = wts';
% filters = 0;
% N=4096;
% freq=(0:N/2)*(16000/N);
% nbFilters=size(wts_act,1);
% fspec = zeros(length(1:N/2+1), nbFilters);
% for i=1:nbFilters
%     f = abs(fft(wts_act(i,:),N));
%     f=f(1:N/2+1);
%     fspec(:,i) = f;
%     filters = filters + f;%/sum(f);
% end
% filters=filters/nbFilters;
% 
% % plot Cumulative frequency response of the model
% figure
% h = plot(freq,filters,'LineWidth',1.5);
% xlabel('Hz')
% %saveas(h,'mdl_freqrspns_1.jpg')
% 
% % plot filters learnt
% figure
% i = imagesc([1:128], freq, fspec);
% xlabel('mth Filter')
% ylabel('Frequnecy (Hz)')
% c = gray;
% c = flipud(c);
% colormap(c);
% colorbar
% %saveas(i,'filtr_all_2.jpg')
%% Spectral analysis
% Specify input and mode for the options: 
% inp = {1:Cry, 2:ZFF}
% mode = {1:Specific frames, 2: a segment}
inp=2;                                                                     % 1 for Cry and 2 for ZFF
mode=1;                                                                    % 1 for Specific frames, 2 for Signal range specified
if inp==1
    inSig = 'Cry';
    filename='/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/wav2/noSil/preProc2/Pain/S35_F_01m_sn1_c30_50_Pain_1.wav';
    wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/13Jan_Layers_Inputs_All/Cry/2Layers_Cry/best_mdlwts_CV1.txt')';
elseif inp==2
    inSig = 'ZFF';
    filename='/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/ZFFOutput2/noSil/preProc2/Pain/S35_F_01m_sn1_c30_50_Pain_1.wav';
    wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/13Jan_Layers_Inputs_All/ZFF/2Layers_ZFF/best_mdlwts_CV1.txt')';
end
[data,fs] = audioread(filename);
data1=(data-mean(data))/std(data);
%% Visualizing energy output and response to the input speech
shift=160;
dW=8;
kW=size(wts,2);
N=2048;
freq=(0:N/2)*(fs/N);
nbFilters=size(wts,1);
countFrames=0;
o = zeros(1, nbFilters);
%%For specific frames
if mode==1    
    cry_data = data1;
    idx_frames = floor([5.435, 6.629, 8.59, 10.23, 12.52]*100);
    nbFrames=length(idx_frames);    
    context=1;
elseif mode==2
    % For a signal segment specified by time instants
    t1 = 8.54;
    t2 = 8.609;
    idx_frame = t1*100;
    cry_data = data1(t1*fs:t2*fs);
    nbFrames=floor((size(cry_data,1))/shift);
    context=0;
    finalResSpec = zeros(N/2+1, nbFrames);
end
len=shift*(2*context+1);
nbPoints=floor((len-kW)/dW)+1;
%% Average over all frames
for i=5:5 %idx:idx %1:length(idx_frames)
    if mode==1
        idx0=(idx_frames(i)-1)*shift+1;
    elseif mode==2        
        idx0=(i-1)*shift+1;
    end    
    idx1=idx0+(2*context+1)*shift-1;
    finalRes=0;
    countFrames=0;
    if (idx0>=1) && (idx1<=size(cry_data,1))
        frame=cry_data(idx0:idx1);
        if mode==1
            figure; plot(frame);
            title(string(inSig)+': Frame no. '+string(idx_frames(i)))
        end
        %compute convolution over frame i
        for j=1:nbPoints
            temp=frame((j-1)*dW+1:(j-1)*dW+kW);
            res = 0;
            %sum over filters
            for k=1:nbFilters
                o(k)=wts(k,:)*temp;
                f = fft(wts(k,:),N);
                f=f(1:N/2+1);
                res=res+o(k)*f;
            end
            res=abs(res);
            res=res/sum(res);
            finalRes=finalRes+res;
            countFrames=countFrames+1;
        end
    end
    finalRes=finalRes/countFrames;
    
    if mode==1
        figure
        plot(freq,finalRes,'-','LineWidth',1)
        xlabel('frequency (Hz)')
        ylabel('S_t')
        title('Response to input for Frame no.'+string(idx_frames(i)))
    elseif mode==2
        finalResSpec(:, i) = finalRes;
    end    
end
%% finalRes=finalRes/countFrames;
% plot filters learnt
if mode==2
    xaxis = [shift/2:shift:length(cry_data)-shift/2]./fs;
    figure
    i = imagesc(xaxis, freq, finalResSpec);
    xlabel('Time (s)')
    ylabel('Frequnecy (Hz)')
    c = gray;
    c = flipud(c);
    colormap(c);
    colorbar
end