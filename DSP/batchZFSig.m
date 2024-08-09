clear all; close all; clc

% Dir1: '/idiap/resource/database/ComParE2019_BabySounds/wav/'
% Dir2: '/idiap/temp/ssharma/Datasetup/ZFFsig_BSS_cumsum/'


path_data = '/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/ssharma/Datasetup/wav2/noSil/preProc2/Anxt/';
path_write = '/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/ssharma/Datasetup/ZFFOutput2/noSil/preProc2/ZFF_cumsum/Anxt/';
path_zff = '/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Codes/DSP/';       


addpath(path_data,path_write,path_zff);
d1 = dir(path_data);
for count = 3:length(d1)
    file_name = d1(count).name();
    if(contains(file_name,'.wav'))
        [wav,fs] = audioread(file_name);
        wav = resample(wav,16000,fs);
        [zf,gci,es,f0] = zfsig(wav/max(abs(wav)),fs);
        audiowrite(strcat(path_write,file_name),zf/max(abs(zf)),fs);
        disp(file_name);
    end
end
disp('DONE');