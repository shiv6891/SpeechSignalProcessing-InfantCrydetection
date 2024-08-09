%%% THIS IS A CODE TO DESIGN RESONATORS %%% 

sampling_freq = 16000; % (in Hz) samplingfrequency
central_freq = 1335.9; % (in Hz) central frequency of resonator
rO = 0.99; %Bandwidth of the resonator
dft_points = 1024; % resolution of the filter

radian_freq = (central_freq/sampling_freq)*2*pi; % normalized central freq
poly_Num = [1]; % numerator polynomial 
poly_Den = [1 -2*rO*cos(radian_freq) rO.^2]; % denominator polynomial 
[resonator_response, freq_axis] = freqz(poly_Num,poly_Den,dft_points); % generating filter response
[anti_resonator_response, ~] = freqz(poly_Den,poly_Num,dft_points); % generating filter response

%%%%%%%%%% FOR MORE RESONATORS 
central_freq_2 = 500; % (in Hz) central frequency of resonator
rO_2 = 0.9; %Bandwidth of the resonator
radian_freq_2 = (central_freq_2/sampling_freq)*2*pi; % normalized central freq
poly_Num_2 = [1]; % numerator polynomial 
poly_Den_2 = [1 -2*rO_2*cos(radian_freq_2) rO.^2]; % denominator polynomial 
[resonator_response_2, ~] = freqz(poly_Num_2,poly_Den_2,dft_points); % generating filter response
[anti_resonator_response_2, ~] = freqz(poly_Den_2,poly_Num_2,dft_points); % generating filter response

central_freq_3 = 2200; % (in Hz) central frequency of resonator
rO_3 = 0.79; %Bandwidth of the resonator
radian_freq_3 = (central_freq_3/sampling_freq)*2*pi; % normalized central freq
poly_Num_3 = [1]; % numerator polynomial 
poly_Den_3 = [1 -2*rO_3*cos(radian_freq_3) rO.^2]; % denominator polynomial 
[resonator_response_3, ~] = freqz(poly_Num_3,poly_Den_3,dft_points); % generating filter response
[anti_resonator_response_3, ~] = freqz(poly_Den_3,poly_Num_3,dft_points); % generating filter response

central_freq_4 = 5700; % (in Hz) central frequency of resonator
rO_4 = 0.9; %Bandwidth of the resonator
radian_freq_4 = (central_freq_4/sampling_freq)*2*pi; % normalized central freq
poly_Num_4 = [1]; % numerator polynomial 
poly_Den_4 = [1 -2*rO_4*cos(radian_freq_4) rO.^2]; % denominator polynomial 
[resonator_response_4, ~] = freqz(poly_Num_4,poly_Den_4,dft_points); % generating filter response
[anti_resonator_response_4, ~] = freqz(poly_Den_4,poly_Num_4,dft_points); % generating filter response
%%%%%%%%%% CUMULATIVE RESPONSE OF ALL RESONATORS

res_additive_response = resonator_response_4+resonator_response_3+resonator_response_2+ resonator_response;
res_multiplicative_response = resonator_response_4.*resonator_response_3.*resonator_response_2.*resonator_response;

anti_res_additive_response = anti_resonator_response_4+anti_resonator_response_3+anti_resonator_response_2+ anti_resonator_response;
anti_res_multiplicative_response = anti_resonator_response_4.*anti_resonator_response_3.*anti_resonator_response_2.*anti_resonator_response;

%%% PLOTTING OF THE FIGURE
figure; 

subplot(2,4,[1 2]);
plot(freq_axis*sampling_freq/(2*pi), abs(res_additive_response),'k','LineWidth',2);
grid; ylabel('|H(\omega)|'); xlabel('freq (Hz)');
title('additive response of resonators');

subplot(2,4,[3,4]);
plot(freq_axis*sampling_freq/(2*pi), abs(anti_res_additive_response),'k','LineWidth',2);
grid; ylabel('|H(\omega)|'); %xlabel('freq (Hz)');
title('additive response of anti-resonators');

subplot(2,4,[5,6]);
plot(freq_axis*sampling_freq/(2*pi), abs(res_multiplicative_response),'k','LineWidth',2);
grid; xlabel('freq (Hz)'); ylabel('|H(\omega)|'); 
title('multiplicative response of resonators');

subplot(2,4,[7,8]);
plot(freq_axis*sampling_freq/(2*pi), abs(anti_res_multiplicative_response),'k','LineWidth',2);
grid; xlabel('freq (Hz)'); ylabel('|H(\omega)|'); 
title('multiplicative response of anti-resonators');

figure;
zplane(poly_Num, poly_Den); hold on;grid;
zplane(poly_Num_2, poly_Den_2); hold on;
zplane(poly_Num_3, poly_Den_3); hold on;
zplane(poly_Num_4, poly_Den_4); 
xlim([-3 3]);ylim([-1.2 1.2]);
