function [fr_coeff,lags,lim95]=fr_ccf(ra,rb,dt,MAXLAG,w,option)
% get firing rate correlation, and Common Drive Coefficient
% Input: 
%      ra and rb: the two firing rates
%             dt: time resolution (msec)
%         MAXLAG: maximum time lag (msec)
%              w: bandwidth of the firing rates (Hz)
%         option: detrending prior to correlation calculation
% Output: 
%             cr: common drive coefficient
%           lags: time lags
%          lim95: 95% confidence interval
%
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3.
%Email: ning.jiang@unb.ca
%
%Date: Mar 5, 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if option
    %detrending...
    hpass=500; %msec
    b=ones(1,hpass/dt);
    b=b/sum(b);
    rat=filter(b,1,ra);
    rbt=filter(b,1,rb);
    ra=ra-rat;
    rb=rb-rbt;
    ra=ra(501:length(ra));
    rb=rb(501:length(rb));
end

if length(ra) > length(rb)
    ra=ra(1:length(rb));
else
    rb=rb(1:length(ra));
end
[fr_coeff,lags]=xcov(ra,rb,MAXLAG/dt,'unbiased');
fr_coeff=fr_coeff/(std(ra)*std(rb));
lags=lags*dt;
lim95=2*sqrt(1/(2*w*dt*length(ra)/1000));