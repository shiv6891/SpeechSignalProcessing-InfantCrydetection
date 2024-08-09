clear;


feat_dir="/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/ssharma/feat/zff_feat/train_feat";
list = dir(feat_dir);
cnt=0;
% Read all dat afrom HDF5 formatted files into matlab
for a = 1:length(list)
    fname = list(a).name;
    if contains(fname,'.h5')
        cnt = cnt+1;
    end
end

hFileN = cnt/2;
segN = 4000;
shift = 160;
overlap = segN-shift;
zff_feat_var_mini = [];
for a = 1:7%hFileN    
    xFile = feat_dir+'/'+string(a)+'.x.h5';
    yFile = feat_dir+'/'+string(a)+'.y.h5';
    fileinfo = h5info(xFile);
    sessNum = length(fileinfo.Datasets);                                        % No of sessions in a file
    for i = 0:sessNum-1
        data = h5read(xFile, '/'+string(i));
        label = h5read(yFile, '/'+string(i));
        xspl1 = repmat(data(:, 1),1,12);
        xspl2 = repmat(data(:, sessNum),1,12);
        data2 = [xspl1,data,xspl2];
        dataVec = data2(:);
        y = buffer(dataVec,segN,overlap, 'nodelay');
        zff_feat = y';
        if size(zff_feat, 1)<64
            zff_feat_mini = zff_feat(1:64,:);
            zff_feat_lab_mini = label(1:64);
        else
            zff_feat_mini = zff_feat(51:115,:);
            zff_feat_lab_mini = label(51:115);
        end    
        zff_feat_var_mini = [zff_feat_var_mini; [zff_feat_mini, zff_feat_lab_mini]];
        disp('Dataset added for '+string(i)+' Session!')
        clear data label xspl1 xspl2 data2 dataVec y zff_feat zff_feat_lab zff_feat_mini zff_feat_lab_mini 
    end
    disp('File ' + string(a) + ' processed successfully!')
    
end
zffFeat = double(zff_feat_var_mini);
xlswrite('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/ssharma/feat/zff_feat/MATLAB_Feat/zff_featf_trainAll_7Fls.csv',zff_feat_var_mini);
clear    


 