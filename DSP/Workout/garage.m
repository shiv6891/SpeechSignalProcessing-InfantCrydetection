% Random workout
% delta:            n = [n1:n2]; x = [(n-n0) == 0];
% unit step:        n = [n1:n2]; x = [(n-n0) >= 0];
% real expo:        n = [n1:n2]; x = (0.9).^n;
% ramp signal:      n = [n1:n2]; x = [n.*((n-n0)>=n0)];
% complex exp:      n = [0:1000]; x = exp((2+2*pi*1000j)*n);
% sinusoidal:       n = [0:100]; x = 3*cos(0.5*pi*n)+2*sin(2*pi*80*pi*n);
% random noise:     rand(1,N) and randn(1,N); (random and normally distributed)
% ---------------------------------------------------------------------------
close all; clear
% lim=1000;
% n1=-lim;n2=lim;n0=0;
% n = [0:100]; 
N=100; x = rand(1,N);
figure
plot(x);hold on; grid
xlabel('time')
ylabel('x[n]')
% title('Representation of complex exponential signal')

%%
% dft_points = 2048;
% % [res, fr] = freqz([1], [1,-4,6,-4,1], dft_points);  % ZF resonator
% [res, fr] = freqz([1], [1,-4,6,-4,1], dft_points);  % ZF resonator
% % [res, fr] = freqz([1, -1], [1], dft_points);
% 
% figure
% plot(fr*sampling_freq/(2*pi), abs(res))
fs=16000;
N=2048;
freq=(0:N/2-1)*(fs/N);
w = 2*pi*freq/fs;
% M=31;
M1=31;
M2=61;
M3=81;
W_Mag1 = abs(sin(w*M1/2))./abs(sin(w/2));
W_Mag2 = abs(sin(w*M2/2))./abs(sin(w/2));
W_Mag3 = abs(sin(w*M3/2))./abs(sin(w/2));
T_Mag1 = hann(M1);
T_Mag2 = hamming(M1);
T_Mag3 = blackman(M1);
figure
plot(freq, W_Mag1, 'k'); hold on
plot(freq, W_Mag2, 'r'); hold on
plot(freq, W_Mag3, 'm');
% plot(abs(fft(T_Mag1, N)/max(abs(fft(T_Mag1, N)))), 'k'); hold on
% plot(abs(fft(T_Mag2, N)/max(abs(fft(T_Mag2, N)))), 'r'); hold on
% plot(abs(fft(T_Mag3, N)/max(abs(fft(T_Mag3, N)))), 'm');
legend('Han', 'Ham', 'Black')
%%
x = 0.91 +0.27i;
abs(x)
angle(x)*180/pi
sqrt(0.91^2+0.27^2)
180/pi*(atan(0.27/0.91))
tan(0.27/0.91)
%%

t = (-1:0.01:1)';
% unitstep = t>=0;
% f=abs(fft(unitstep, 2048));
% figure;
% plot(freq, f(1:N/2)/max(f));
w1=500*2*pi;
w2=2000*2*pi;
x1 = sin(t*w1);
x2 = sin(t*w2);

figure;
subplot(2,1,1)
plot(x1)
subplot(2,1,2)
plot(x2)



   %%Time specifications:
   Fs = 8000;                   % samples per second
   dt = 1/Fs;                   % seconds per sample
   StopTime = 0.25;             % seconds
   t = (0:dt:StopTime-dt)';     % seconds
   %%Sine wave:
   Fc = 60;                     % hertz
   Fc2 = 350;                     % hertz
   x = sin(2*pi*Fc*t);
   y = cos(2*pi*Fc2*t);
   % Plot the signal versus time:
   figure;
   plot(t,x);
   xlabel('time (in seconds)');
   title('Signal versus Time');
   zoom xon;


z = x+y;

   
f1=abs(fft(y, 2048));
figure;
plot(freq, f1(1:N/2));
   
   
   
   

w1c=750;
rO = 0.9;

w2c=3500;
rO_2 = 0.9;

sampling_freq = 8000; % (in Hz) samplingfrequency
central_freq = w1c; % (in Hz) central frequency of resonator
% rO = exp(-pi*(w1h-w1l)*1/sampling_freq); %Bandwidth of the resonator
% rO = 0.99; %Bandwidth of the resonator
dft_points = 2048; % resolution of the filter


radian_freq = (central_freq/sampling_freq)*2*pi; % normalized central freq
poly_Num = [1]; % numerator polynomial 
poly_Den = [1 -2*rO*cos(radian_freq) rO.^2]; % denominator polynomial 
[resonator_response, freq_axis] = freqz(poly_Num,poly_Den,dft_points); % generating filter response
[anti_resonator_response, ~] = freqz(poly_Den,poly_Num,dft_points); % generating filter response

%%%%%%%%%% FOR MORE RESONATORS 
central_freq_2 = w2c; % (in Hz) central frequency of resonator
% rO_2 = exp(-pi*(w2h-w2l)*1/sampling_freq); %Bandwidth of the resonator
% rO_2 = 0.9;
radian_freq_2 = (central_freq_2/sampling_freq)*2*pi; % normalized central freq
poly_Num_2 = [1]; % numerator polynomial 
poly_Den_2 = [1 -2*rO_2*cos(radian_freq_2) rO_2.^2]; % denominator polynomial 
[resonator_response_2, ~] = freqz(poly_Num_2,poly_Den_2,dft_points); % generating filter response
[anti_resonator_response_2, ~] = freqz(poly_Den_2,poly_Num_2,dft_points); % generating filter response
figure
plot(freq_axis*sampling_freq/(2*pi), abs(resonator_response),'k','LineWidth',2);grid; 
figure
plot(freq_axis*sampling_freq/(2*pi), abs(resonator_response_2),'k','LineWidth',2);grid; 

%Parallel
y1_par = filter(poly_Num, poly_Den, unitstep);
f1_par_F = abs(fft(y1_par, 2048));
figure;
plot(freq, f1_par_F(1:N/2)/max(f1_par_F));

y2_par = filter(poly_Num_2, poly_Den_2, unitstep);
f2_par_F = abs(fft(y2_par, 2048));
figure;
plot(freq, f2_par_F(1:N/2)/max(f2_par_F));

y = y1_par+y2_par;
y_par_F = abs(fft(y, 2048));
figure;
plot(freq, y_par_F(1:N/2)/max(y_par_F));

% Cas

y1_cas = filter(poly_Num, poly_Den, unitstep);
f1_cas_F = abs(fft(y1_cas, 2048));
figure;
plot(freq, f1_cas_F(1:N/2));

y2_cas = filter(poly_Num_2, poly_Den_2, y1_cas);
f2_cas_F = abs(fft(y2_cas, 2048));
figure;
plot(freq, f2_cas_F(1:N/2));

y = y1_par+y2_par;
y_par_F = abs(fft(y, 2048));
figure;
plot(freq, y_par_F(1:N/2)/max(y_par_F));

%%

[x, fs]=audioread('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Codes/PitchAnalysis/Codes/Voice_Sample_Exp4_183 ms.wav');
figure;
plot([1:length(x)]/fs, x)

shift=0.030*fs;
x1 = x(0.0045*fs:0.0045*fs+shift);
f1 = abs(fft(x1, 2048));
freq = [1:1024]*fs/2048;
figure
plot(freq, f1(1:1024));

figure;
plot([1:length(x1)]/fs, x1)


y1_par = filter(poly_Num, poly_Den, x1);
f1_par_F = abs(fft(y1_par, 2048));
figure;
plot(freq, f1_par_F(1:N/2));

y2_par = filter(poly_Num_2, poly_Den_2, x1);
f2_par_F = abs(fft(y2_par, 2048));
figure;
plot(freq, f2_par_F(1:N/2));

% Parallel
y_par = y1_par+y2_par;
f_par = abs(fft(y_par, 2048));
figure
plot(freq, f_par(1:1024));
title('F_Par')

[resonator_response, freq_axis] = freqz(poly_Num,poly_Den,dft_points); % generating filter response



% Cascade

y_cas1 = filter(poly_Num, poly_Den, x1);
y_cas2 = filter(poly_Num_2, poly_Den_2, y_cas1);
f_cas = abs(fft(y_cas2, 2048));
figure
plot(freq, f_cas(1:1024));
title('F_Cas')

