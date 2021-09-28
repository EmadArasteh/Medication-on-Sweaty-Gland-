clc;
close all;
clear;
load('TEMP_similar_freq_initial.mat')
load('Medication.mat')
Fs=4;
upper_freq=5e-3;
for index_list=1:size(Med_time,1)   
    clear('idx','idxx')
    index_list
    sig2=vec_output_time(index_list,:);
    sig1=vec_input_time(index_list,:);
    [Cxy,f] = mscohere(sig1,sig2,[],[],[],Fs);
Pxy = cpsd(sig1,sig2,[],[],[],Fs);
% 
% 
% phase_degree= (-angle(Pxy)/pi*180);
phase_rad=(angle(Pxy));

idx=find(f<=upper_freq);

[pks{index_list},locs{index_list}] = findpeaks(Cxy(idx),'MinPeakHeight',0.55,'Threshold',.1);
delta_t{index_list}=phase_rad(locs{index_list})./(2*pi*f(locs{index_list})*60*60);


% idxx=find(abs(delta_t{index_list}(:))>3 | delta_t{index_list}(:)>0);
% delta_t{index_list}(idxx)=[];
sum_med(index_list)=sum(Medication(index_list,:));
sum_spectrum(index_list)=numel(locs{index_list}(:));
    figure
subplot(3,1,1)
plot(f,Cxy)
% title('Coherence Estimate')
% xlim([0 upper_freq])
% grid on
% subplot(3,1,2)
% plot(f,phase_degree)
% title('Cross-spectrum Phase (deg)')    
% xlim([0 upper_freq])
%   subplot(3,1,3)
% plot(linspace(0,23,numel(sig1)),sig1)  
end
sum_spectrum
[R,P]=corrcoef(sum_spectrum,sum_med)