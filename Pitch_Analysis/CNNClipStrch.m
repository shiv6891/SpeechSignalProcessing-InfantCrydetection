% The present code trims the aviable extended signals into excerpts of 5 
% sec equally trimmed from the center
clear
list = ls('D:\Shivam\Research_IIITS\Experiments\CryCNN\CNNData\RawLen\Non_severe\*.wav');
% fileList = list(3:end,:);
n = size(list, 1);

for i = 3:n
    fName = list(i,:);    
    fileName = strtrim(fName);    
    [x, fs] = audioread(fileName);    
%     Read the file and extract the mmiddle 5 seconds from the file (if of sufficient length)
    if (length(x)<(5*48000))
        display(strcat(strcat(strcat('Processing File Number:', num2str(i)), ', Name:'), list(i,:)));
        newFName = strrep(fileName,'.wav', '_5s');
        p2 = (5*48000)-length(x);
        x2 = [x;x(1:p2, :)];
        size(x2)
        cd 'D:\Shivam\Research_IIITS\Experiments\CryCNN\CNNData\ICSD2_40_5s\Non_severe\'
        audiowrite(strcat(newFName, '.wav'), x2, fs);
    end
    clearvars x2 p1 fileName fName;
end
    