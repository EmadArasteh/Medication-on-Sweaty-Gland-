clc;
clear;
close all;

%%
 load('list.mat')
load('Medication.mat')
inside={'HR'};
        P = 'E:\Human && Science\science\cognitive\prof. Mirian\EDA\5\';
 
lev = 5;
wname = 'sym8';


for index_list=1:numel(list)
    index_list



    
   index_test=1;


F = sprintf('%s%s\\',P,list{index_list});
E=sprintf('%s%s.csv',F,inside{index_test});

sigg=  load(E);
sig=sigg(3:end);
signal_HR{index_list}=sig./max(abs(sig));


dnsignal_HR{index_list} = wdenoise(sig,lev,'Wavelet',wname,...
    'DenoisingMethod','UniversalThreshold',...
    'ThresholdRule','Soft',...
    'NoiseEstimate','LevelDependent');


    freq_sample{index_list}=numel(signal_HR{index_list})/(time_dur(index_list)*60*60);
    
    
    
    
end


clearvars -except signal_HR dnsignal_HR freq_sample
 load('list.mat')
load('Medication.mat')
signal_conisdered=dnsignal_HR;


upper=.1;
mean=1*60*60;
fs_standard=4;
t_standard=0:1/fs_standard:60*60*23;
pd = makedist('Weibull','a',mean,'b',2);
x = pdf(pd,t_standard);
x=x./max(x);
X=fftshift(fft(x))/numel(x);
freq_X=fs_standard.*(0:numel(X)-1)/numel(X);
freq_X=freq_X-median(freq_X);
[~,I]=max(time_dur);
num=zeros(numel(time_dur),1);
save('freq_input.mat','freq_X','X')

for index_list=1:size(Medication,1)    
clear('s0','t0')
 clear('cc','idx','summation','chosen_freq1','chosen_freq2','frequency_output')
     
    index_list
   if time_dur(index_list)>24
       ratio=(time_dur(index_list)-24)/time_dur(index_list);
       num(index_list)=round(ratio*numel(signal_conisdered{index_list}));
   
   end  
   s0=signal_conisdered{index_list};
   t0 = linspace(0,(time_dur(index_list)-1)*60*60,numel(s0))';
   signal(index_list,:)=interp1( t0,s0,t_standard);
   signal_spec(index_list,:)=fftshift(fft(signal(index_list,:)))/numel(t_standard);





 
idx{index_list}=find(Medication(index_list,:)==1);

cc=[];
for i=1:numel(idx{index_list})
cc(i,:)=exp(-1i.*2*pi.*freq_X.*(idx{index_list}(i)).*60.*60);
end
summation=sum(cc);



vec_input(index_list,:)=summation.*X;
vec_input_time(index_list,:)=real(ifft(ifftshift(vec_input(index_list,:))))/numel(X); 

vec_output(index_list,:)=signal_spec(index_list,:);
vec_output_time(index_list,:)=signal(index_list,:);

%   figure;
%  plot(t_standard,vec_input_time(index_list,:))
x1=Medication(index_list,:);

          Med_time(index_list,:)=resample(x1,numel(vec_output_time(index_list,:)),24);
      Med_time(index_list, Med_time(index_list,:)<.95)=0;
     
end
save('HR_similar_freq_initial','Med_time','vec_output','vec_output_time','vec_input','vec_input_time')
