%**************************************************************************
%**********************       autocorr_V8bmedFil **************************
%**************************************************************************
%   Objective: Instantaneous F0 Contour (values) extraction using ACF
%   Obtains the Instantaneous F0 contour values by performing the
%   following:
%   --> Take the successive average of FIRST 3 PEAKS (First 2 are fixed by default...need change)
%   --> Discards the spurious T0's
%   --> Takes observation period dynamically by taking the max peak
%   --> Considers the previous frame inputs for consistent peak picking
%**************************************************************************
%   Recieved from:  Dr. Vinay Mittal
%   Upgraded by:    Shivam Sharma
%   Date:           16/05/2016
%   Update1:        17/05/2016  autocorr_avt0_V2a  Added the removal of the spurious T0's (C:\Shivam\Research @ IIITS\Music Source Separation\Phase III\pitch Extraction\Experiments\Experiments_V6\ACF
%                   Upgrade: Page 2, II criteria)
%   Update2:        18/05/2016  Modified the permissible limit from +/- 2 --> +/- 3. LOC:   134
%   Update3:        19/05/2016  Automatic the T1:T3 computing process
%   Update4:        20/05/2016  Added incremental Averaging steps Lines.
%                               LOC: 144-170
%   Update5:        20/05/2016  18:40   Replace the ratio averaging logic with the
%                                       discrete operation. LOC: 173
%   Update6:        20/05/2016  18:53   Modified the permissible limit from +/- 3 --> +/- 5. LOC:   134
%                                       Due to change for the second Frame inclusiveness for  "4_M2_Sa"
%   Update7:        30/05/2016  17:13   Modification to take the dynamic period done
%                                       LOC: 146-149 and some more
%                                       iteration condition modifications.
%   Update8:        31/05/2016  30% below threshold changed to selecting
%                               the sample value corresponding to the max
%                               peak (autocorr_avt0_V3a: Update9)
%   Update9:        01/06/2016  bval's space, for the peak consideration in
%                               the obervation period, extended to +20.
%                               LOC: 168 (autocorr_avt0_V3a: Update10)
%   Update10:       01/06/2016  19:00   bval's space, for the peak consideration in
%                                       the obervation period, extended to +100 for
%                                       consideration of 10_M5_Sa (autocorr_avt0_V5a Update11)
%   Update11:       15/06/2016  19:08   Upgrade V5 --> V6;  Buffer value
%                                       logic added, considering different Sampling frequencies
%                                       Fs: 48000, bufval = 100;
%                                       Fs: 10000, bufval = 20;
%   Update12:       21/07/2016  12:12   Logic added for the correct output
%                                       of the first frame for T1T3rat
%                                       value near LOC: 288, 288-290
%   ***********************************************************************
%   Update13:       31/07/2016  12:00   Buffering mechanism being changed from
%                                       'no delay' to 'opt', with opt
%                                       equals to the OVERLAP from the last
%                                       Frame. (In progress)
%
%   ***********************************************************************
%   Update14:       10/10/2016  00:45   LOC: 109-111, 275-279; Added neighbouring frame
%                                       processing for consistent Peak picking
%   Update15:       12/10/2016  11:55   LOC: 346-355; Modified the
%                                       averaging for Peak Periods from each frame, to consider "only the non
%                                       zero values" For eg. PeakP = [66, 67, -134]
%   Update16:       12/10/2016  15:49   LOC: 312-314; Bifurcated the k<3
%                                       logic into for k = 1 and 2 respectively
%   Update17:       12/10/2016  18:01   LOC: 318-326; Pre occurance of the
%                                       spurious peak in a period considered, using the previous pitch value
%   Update18:       12/10/2016  19:42   LOC: 322; The range values changed
%                                       from +/- 5 to +/- 15
%   Update19:       13/10/2016  03:41   LOC: 110-113; Neighbouring buffer values; Nbuff: +/-10 for Fs =8000; +/-50 for Fs = 48000
% Inputs:
%   x: Signal
%   fs: sampling frequency
%   fsize,fshift in ms.
%   If plotFlag == 0, no plots are generated.
%   ***********************************************************************

function [f0, xaxis, t0] = autocorr_V8bmedFilt(x,fs,fsize,fshift,plotFlag, dflag)


% Convert from milliseconds to samples
N = floor(fsize*fs/1000);
L = floor(fshift*fs/1000);
P=N-L;
minT0 = floor(2.5*fs/1000);

optP = x(1:P);
y = x(P+1:end);

% x = residual;
% fs = fs2;
% Preemphasize the signal and Arrange speech into blocks.
if (dflag == 1)
    s = diff(y);
    s(length(y)) = s(end);
    bufs = buffer(s,N,N-L,optP);
    bsig = s;
else
    bufs = buffer(y,N,N-L,optP);
    bsig = y;
end

[r,c] = size(bufs);
c


% Compute autocorrelation for each block.
for i=1:c
    
    % ac1 is two-sided autocorrelation.
    ac1 = xcorr(bufs(:,i));
    
    % ac is one-sided autocorrelation.
    ac = ac1(N:2*N-1);
    
    % Check if the signal segment has zero energy.
    if max(ac1) ~= 0
        ac = ac/max(ac1);
    end
    
    % Plot signal and autocorrelation for each block.
    if plotFlag == 2
        
        %**************************************************************************
        %Uncomment for specific frames
        %**************************************************************************
        
%                 if (i==1)
                    figure;
                    bx(1)=subplot(3,1,1);
                    plot([1:r]*1000/fs, bufs(:,i), 'k');grid;
%                     title('Fig. a: Raw-->Diff-->DS at 10 K-->LP Res');
                    title('Fig. a: Raw input cry signal');
                    bx(2)=subplot(3,1,2);
                    plot([1:r]*1000/fs, ac,'k');grid;
                    str=sprintf('Fig. b: Autocorrelation for Frame # %d', i);
                    title(str);
                    linkaxes(bx, 'y');
                    xlabel('Time (ms)');
                    %         j = j+1;
%                 end
    end
        
        %**************************************************************************
%         %**************************************************************************
%         % Uncomment for quardruple ACF output from DIFFERENT kind of signals
%         %**************************************************************************
%         %
%         if (i==1)
%             %             bx(1)=subplot(2,2,cnt);
%             %             plot([1:r]*1000/fs, bufs(:,i), 'k');grid;
%             %             if (cnt == 1)
%             %                 title('Fig. a: Raw Input Signal');
%             %             else
%             %                 title('Fig. c: Differenced Signal');
%             %             end
%             %             ylabel('a');
%             bx(cnt)=subplot(4,1,cnt);
%             plot([1:r]*1000/fs, ac,'k');grid;
%             %             ylabel();
%             if (cnt == 1)
%                 str=sprintf('Fig. 1.c: Autocorrelation for Raw input signal for Frame # %d', i);
%                 title(str);
%                 cnt = cnt+1;
%             else
%                 if (cnt == 2)
%                     str=sprintf('Fig. 1.d: Autocorrelation for (Raw input signal + Diff) for Frame # %d', i);
%                     title(str);
%                     cnt = cnt+1;
%                 else
%                     if (cnt == 3)
%                         str=sprintf('Fig. 2.c: Autocorrelation for (Raw-->DS 10K-->LPRes) for Frame # %d', i);
%                         title(str);
%                         cnt = cnt+1;
%                     else
%                         if (cnt == 4)
%                             str=sprintf('Fig. 2.d: Autocorrelation for (Raw-->Diff-->DS 10K-->LPRes) for Frame # %d', i);
%                             title(str);
%                             cnt = cnt+1;
%                         end
%                     end
%                 end
%             end
%             linkaxes(bx, 'y');
%             xlabel('Time (ms)');
%             %             %         j = j+1;
%         end
%     end
    
    %**************************************************************************
    %**************************************************************************
    %Uncomment for a quardruple from the same signal
    %**************************************************************************
    % i<5
    % (i>4&&i<9)
    % 	if i<5
    % 		bx(i)=subplot(2,2,j);
    % 		plot([1:r]*1000/fs, ac,'k');grid;
    %         str=sprintf('Autocorrelation for Frame # %d', i);
    %         title(str);
    %         linkaxes(bx, 'y');
    % 		xlabel('Time (ms)');
    %         j = j+1;
    %     end
    %   Uncomment for original processing	(single frame debug)
    %%*************************************************************************
    % 		bx(1)=subplot(2,1,1);
    % 		plot([1:r]*1000/fs, bufs(:,i), 'k');grid;
    %
    % 		bx(2)=subplot(2,1,2);
    % 		plot([1:r]*1000/fs, ac,'k');grid;
    %
    % 		linkaxes(bx, 'y');
    % 		xlabel('Time (ms)');
    %pause;
    % 	end
    
    
    
    % Detect  peaks in autocorrelation sequence.
%     ac(1:minT0) = 0; %%Try out for cases below Fsize 10 ms--> Doesn't Works out!
    
    y1 = [diff(ac) > 0]; 	% Positive y1 indicates increasing trend.
    y2 = [diff(ac) <= 0];	% Positive y2 indicates decreasing trend.
    
    % Identify 1-0 transitions in y1, or identify 0-1 transition in y2.
    [locPeaks] = find((y1(1:length(y1)-1) + y2(2:length(y2))) == 2);
    if isempty(locPeaks) == 0
        locPeaks = locPeaks(:) + ones(length(locPeaks),1);
        %         %*****************************************
        %         plotFlag=4;
        %**************************************************************************
        %   For Special, signal + Peak output plot
        if (plotFlag == 4)
            %%%
            if (i>=57 && i<=67)
                figure;
                bx(1)=subplot(2,1,1);
                plot([1:r]*1000/fs, bufs(:,i), 'k');grid;
                bx(2)=subplot(2,1,2);
                plot(ac,'k');grid;
                xlabel('Time (ms)');
                hold on;
                plot(locPeaks, ac(locPeaks), 'ro');
                str=sprintf('Autocorrelation for Frame # %d', i);
                title(str);
                %             linkaxes(bx, 'y');
                xlabel('Samples');
            end
            %%%
        end
        %**************************************************************************
        %**************************************************************************
        %   Simple Peak output plot
        %         figure;
        %         plot(ac);
        %         hold on;
        %         plot(locPeaks, ac(locPeaks), 'ro');
        %         xlabel('Time in ms');
        %         end
        %**************************************************************************
                    [acmaxval(i),pos] = max(ac(locPeaks));                        %max peak value with its location.
        		maxpos(i) = locPeaks(pos);
    else
        acmaxval(i) = 0.001;
        maxpos(i) = 1;
    end
    
    clear y1 y2 locPeaks;
       
end

% Median filtering
t0 =  medfilt1(maxpos,3)./fs;
f0 = 1./t0;
% Average filtering of the F0 estimates
% Experimentations from 21 May, 2018
% filtO = 3;
% coeffMean = ones(1, length(t0))/filtO;
% filter(coeffMean, 1, f0);

xaxis = [floor(N/2):L:floor(N/2) + (c-1)*L + 2]/fs; % In seconds.

if plotFlag == 1
    % 	ax(1) = subplot(4,1,1);
    % 	plot([1:length(x)]/fs, y, 'k');
    % 	xlim([1/fs length(y)/fs]);
    % 	ylim([-1 1]);
    %
    % 	ax(2) = subplot(4,1,2);
    % 	plot(xaxis, acmaxval, 'k');
    % 	xlim([1/fs length(y)/fs]);
    % 	ylim([0 1]);
    %
    % 	ax(3) = subplot(4,1,3);
    % 	plot(xaxis, t0,'k.');
    % 	xlim([1/fs length(y)/fs]);
    % 	ylim([0 15]);
    % 	ylabel('(ms)');
    
    bx(3) = subplot(3,1,3);
    plot(xaxis, f0,'k.');
    title('F0 contour using Autocorrelation, Frame Size = 30 ms, Frame Shift = 10 ms');
    xlim([1/fs length(y)/fs]);
    % 	ylim([0 15]);
    ylabel('(ms)');
    
    % 	linkaxes(ax, 'x');
    
    xlabel('Time (s)');
    
end
end
