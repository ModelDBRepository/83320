function [interval,abnormal]=get_interval(x,t,option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%convert simulation signals (trajectories of memebrane action potentials) into spike timing
%input:
%    x: the membrane action potential
%    t: time course of the simulation
%    option: output time of firings or firing intervals. 0 for intervals, 1 for time of firings
%output:
%    intervals: timing (or intervals) of the firings
%    abnormal: extremely short intervals (refractory period check)
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3.
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin == 2
    option =0;
end

temp=find(x>=0);
time=t(1);
abnormal=0;
if ~isempty(temp)
    if temp(1) == 1 && x(2) < 0
        time=[time,t(1)];
    end

    for n=2:length(temp)-1        
        %detecting the falling edge of the spikes 
        if temp(n+1)~=temp(n)+1 && temp(n-1)==temp(n)-1  
            if t(temp(n))-time(length(time))<=25 && length(time)>2
                disp(sprintf('abnormal spike: %g detect at %g th spike',t(temp(n))-time(length(time)),length(time)));
                abnormal=[abnormal,length(time)-1];
            end
            time=[time,t(temp(n))];
        end
    
    end

    if temp(n+1) ~= length(x) 
        time=[time,t(temp(n+1))];
    end
    

    if option
        interval=time(2:length(time));
    else
        interval=diff(time);
    end
else
    interval=0;
end

abnormal=abnormal(2:length(abnormal));