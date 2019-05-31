function [Instan_Rate]=IFR(timing,tau,dt,starting,ending,option)
% Obtaining the smoothed firing rate of a firing sequence.
% Inputs:
%           timing: the firing timing, NOT INTERVALS;
%              tau: the smoothing window width (in msec)
%               dt: time resolution (in msec)
%         starting: the starting point of the segment to be analyze (in seconds)
%           ending: the ending point of the segment to be analyze (in seconds)
%           option: window selection:'hanning' or 'rect'
% Output:
%      Instan_Rate: the smoothed firing rate (Hz, or pulses/second)
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3
%Email: ning.jiang@unb.ca
%
%Date: Nov 10, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%timing is the actual sampling points
if starting >= 2*tau/1000
    starting=round((starting*10^3-2*tau)/dt);
else
    disp(['FORCING STARTING POINT AT ',num2str(2*tau),' msec!']);
    starting=0;
end
if ending <=timing(end)
    ending=round(ending*10^3/dt);
else
    disp('FORING ENDING POINT AT THE END OF RECORD!');
    ending=timing(end)*10^3/dt;
end
timing=round(timing/dt);

%generating pulse train
ind=find(timing<starting);
ind=length(ind)+1;
pulse_train=[zeros(1,timing(ind)-starting-1),1];

while timing(ind) <= ending && ind < length(timing)
    ind=ind+1;
    pulse_train=[pulse_train,zeros(1,timing(ind)-timing(ind-1)-1),1];
end
pulse_train=pulse_train(1:(ending-starting));


switch option
    case 'hanning'
        a=1;
        b=hann(tau/dt); 
        b=b/sum(b);
        Instan_Rate=filter(b,a,pulse_train);
    case 'rect'
        a=1;
        b=ones(1,tau/dt);
        b=b/sum(b);
        Instan_Rate=filter(b,a,pulse_train);
        
    case 'highpass'
end
        
Instan_Rate=Instan_Rate((1+2*tau/dt):length(Instan_Rate));
Instan_Rate=Instan_Rate*1000/dt;