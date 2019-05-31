function cdfun=gene_cdfun(rms,stepsize,duration,option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This routine generates a common input (CI) function (for Common Drive purpose)
%Inputs:
%rms:       the rms value of the resuling common input function
%stepsize:  the stepsize for the HH (simulator), in msec
%duration:  the duration of the common input function (simulation data
%length), in seconds.
%option:    option =1 --> detrending included; option=0 -->no detrending
%%lwin_size: the time window width of low pass filter
%hwin_size: the time window width of the highpass filter (de-trending
%filter), as described by DeLuca et al.
%
%output:
%cdfun: the common input function
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 4
    lwin_size=400; %400 ms rectangular time window
    hwin_size=500; %500 ms rectangular time window
end

%filter width considering stepsize
a_lwinsize=lwin_size/stepsize;
a_hwinsize=hwin_size/stepsize;

%normalize rms value
b=hann(a_lwinsize);
b=b/sum(b);
%the variance of the 'cdfun' after lowpass filtering
%denoted by Y, is a function of the variance of the 'cdfun' before lowpass
%filtering, since the lowpass filtering is just a moving average operation:
%Var(y)=Var(x)*sum(ai.^2)
%where ai is the coefficient of the filter of choice (here is hanning
%filter)
a_rms=rms/(sqrt(sum(b.^2)));
cdfun=randn(1,(duration*1000/stepsize)+a_lwinsize+a_hwinsize+1)*a_rms;
cdfun=filter(b,1,cdfun);
if option == 1
    b=ones(1,a_hwinsize)/a_hwinsize;
    tmp=filter(b,1,cdfun);
    cdfun=cdfun-tmp;
end
cdfun=cdfun(a_lwinsize+a_hwinsize+1:length(cdfun));