function yint(togHandle, handles)
% YINT YIN for Tuner
%      YINT(TH,H) handles all the process for the switched on tuner. 
%      Captures sound, estimates pitch using YIN, and sends the results to 
%      GUI repeatedly until the tuner is switched off. TH is the calling 
%      component's handle and H is the global handles structure.
%
%      Copyright (c) 2015 Dalatsis Antonios
%      ICSD, University of the Aegean

fs=44100;        %rec sample rate
noiselvl=0.005;  %relative to mic rec lvl
accuracy=1;      %exaples: 2 1 0.1 0.01 (Hz) / 0 (cents)
flat=0;          %choices: 0 1 (#/b)

fmin=40;
fmax=fs/4;
Tmin=fix(fs/fmax);
Tmax=fix(fs/fmin);
W=Tmax;
hop=35;
W=ceil(W/hop)*hop;
Buf=3*W;

idle=0;
off=1;
offdelay=0;


while ishandle(togHandle) && get(togHandle,'Value') == get(togHandle,'Max')

% capture
x = wavrecord(Buf,fs,1)';

% level check
if max(x(1:W))<noiselvl
    if ~idle, tic; idle=1; else idle=toc; end
    if idle > offdelay && ~off, switchoff(handles); off=1; end
    drawnow;
    continue
end
idle=0; off=0;

% run YIN
d = dfopt(x,W,hop);
d = cmndf(d);
[dx dy] = pin(d);
ind = at(dx,dy,[Tmin,Tmax]);
[T0x T0y] = ble(dx,dy,ind);
T0=T0x(find(T0y==min(T0y),1));
f0=fs/T0;

% match note
[note,dif] = matchfr(f0,flat,accuracy);

% UI update
set(handles.text_note, 'String', note);
set(handles.text_freq, 'String', sprintf('%.1f', f0));
set(handles.text_diff, 'String', dif);
ledlights(handles,dif,accuracy);
gauge(handles,dif,accuracy);
drawnow;
end




function gauge(handles,sdif,acc)
% move needle according to estimation-match difference
dif=str2num(sdif);
if acc==0, n=round(dif/2.5)+21; else n=round(dif/acc)+21; end
if n<1, n=1; elseif n>41, n=41; end
axes(handles.naxes);image(handles.n{n},'AlphaData',handles.na{n}),axis off;




function ledlights(handles,sdif,acc)
% switch leds according to estimation-match difference
dif=str2num(sdif);
if acc==0, thres=8; else thres=0; end
if dif>thres
    axes(handles.laxes);image(handles.oled,'AlphaData',handles.a),axis off;
    axes(handles.maxes);image(handles.oled,'AlphaData',handles.a),axis off;
    axes(handles.raxes);image(handles.rled,'AlphaData',handles.a),axis off;
elseif dif<-thres
    axes(handles.laxes);image(handles.rled,'AlphaData',handles.a),axis off;
    axes(handles.maxes);image(handles.oled,'AlphaData',handles.a),axis off;
    axes(handles.raxes);image(handles.oled,'AlphaData',handles.a),axis off;
else
    axes(handles.laxes);image(handles.oled,'AlphaData',handles.a),axis off;
    axes(handles.maxes);image(handles.gled,'AlphaData',handles.a),axis off;
    axes(handles.raxes);image(handles.oled,'AlphaData',handles.a),axis off;
end




function switchoff(handles)
% put leds and needle in idle state
axes(handles.laxes);image(handles.oled,'AlphaData',handles.a),axis off;
axes(handles.maxes);image(handles.oled,'AlphaData',handles.a),axis off;
axes(handles.raxes);image(handles.oled,'AlphaData',handles.a),axis off;

axes(handles.naxes);image(handles.n{1},'AlphaData',handles.na{1}),axis off;




function [d] = cmndf(d)

[m,n]=size(d);

for j=1:n
    dsum=0;
    for i=1:m %(i==ô)
        dsum=dsum+d(i,j);
        d(i,j)=d(i,j)/(dsum/i);
    end
end
% figure;plot(1:m,d(:,1)); title('CMNDF'); xlabel('(samples)'); %plot 1st




function [xi,yi] = pin(y)

[m,n]=size(y);

xi = nan(m,n);
yi = nan(m,n);
for j=1:n
for i=2:m-1
    y1=y(i-1,j); y2=y(i,j); y3=y(i+1,j);
    if((y2<=y1) && (y2<=y3))
        a = (y1 + y3 - 2*y2)/2;
        b = (y3 - y1)/2;
        if (a)
            xi(i,j) = i - b / (2*a);        % interpolated x
            yi(i,j) = y2 - (b*b) / (4*a);   % interpolated y
        end
    end
end
end
% figure;plot(1:m,y(:,1));hold on;plot(xi(:,1),yi(:,1),'.'); %plot 1st




function [ind] = at(dx,dy,range)

thres=0.1;

[m,n]=size(dy);
lo=range(1);hi=range(2);
ind=nan(1,n);

for j=1:n
    minv=inf;p=lo;
    for i=lo:hi
        if dy(i,j)<minv, minv=dy(i,j); p=i; end
        if dy(i,j)<thres, p=i; break; end
    end
    ind(j)=p+(j-1)*m; %index
end




function [T0x,T0y] = ble(dx,dy,ind)

T0x = dx(ind);
T0y = dy(ind);

best = T0x(find(T0y==min(T0y),1)); %best estimate

lo=fix(best*0.8); lo=max(1,lo);
hi=fix(best*1.2); hi=min(size(dx,1),hi);

ind = at(dx,dy,[lo hi]);

T0x = dx(ind);
T0y = dy(ind);




function [note,difa] = matchfr(f0,flat,acc)
% match estimation to nearest note
n1={'C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B'};
n2={'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
d=12*log2(f0/440);   %distance from A4
d=round(d);          %best match
i=mod(9+d,12)+1;     %chromatic index
o=floor((9+d)/12)+4; %octave
if flat==1, n=n1{i}; else n=n2{i}; end
note=[n num2str(o)];

if acc==0
    dif = 1200*log2( f0 / (440*2^(d/12)) );
    difa = num2str(round(dif));
else
    dif=f0-440*2^(d/12);
    % difference precision
    s=num2str(acc); a=length(s(find(s=='.')+1:end));
    form=['%.' num2str(a) 'f'];
    difa=sprintf(form,dif);
    if strcmp(difa,'-0'), difa='0'; end
end