function [coeff,lags]=cch(ia,ib,T,resolution)
% Calculating the cross-correlation histogram of two spike interval sequence
% with N bins and a time span of T.
% Inputs: 
%        ia and ib: the two input sequence of firing intervals, in msec
%                T: the maximum time lag, in msec
%       resolution: the time resolution of the histogram, in msec
% Outputs:
%             corr: cross-correlation
%             lags: time lags
%            coeff: normalized cross-correlation
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3
%Email: ning.jiang@unb.ca
%
%Date: Mar 5, 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eta=1/resolution;
corr=0;
reference=0;
referenee=ia(1);
ia=round(ia/resolution);
ib=round(ib/resolution);

%creating referenee train, an increasing sequence representing the timing of the reference unit.
for l=1:length(ia)-1
    temp=referenee(l)+ia(l+1);
    referenee=[referenee,temp];
end

%finding firings in reference train with that is in (-T,T) range of a firing in referenee train
for n=1:length(ib)
    reference=reference+ib(n);
    temp=referenee-reference;
    corr=[corr,temp(find(abs(temp)<T))];   
    %corr=[corr,temp(find(abs(temp)<T*eta))];   
    
end
corr=corr(2:length(corr));

%generate the bin edges of the histogram
lags=(-T*eta+1:T*eta)/eta;

%get histogram and get correlation. coounts equals the correlation calculated by Function :xcorr(ia,ib,T), i.e. not normalized correlation. 
counts=histc(corr,lags);
lags=lags(1:length(lags)-1);

counts=counts(1:length(counts)-1); 
corr=counts*eta;%compensate for eta

% length of recording, in msec
t=referenee(length(referenee));


%getting statistics of a firing train of 1's (a firing) and 0's (time between firings) 
%mean of the two firing trains
mean_a=length(ia)/(t*eta);
mean_b=length(ib)/(t*eta);
%variance of the two firing trains
var_a=((1-mean_a)^2*length(ia)+mean_a^2*(t-length(ia)))/(t*eta);
var_b=((1-mean_b)^2*length(ib)+mean_b^2*(reference-length(ib)))/(reference*eta);
crossvar=sqrt(var_a*var_b);
%cova of the two firing trains: normalized correlation minus product of the
%two means
cova=counts/(t*eta)-mean_a*mean_b;
%correlation coefficient
coeff=cova/crossvar;
