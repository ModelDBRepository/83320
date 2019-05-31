function b=hann(N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hanning window. This function is for systems that does not have Signal
% Processing Toolbox installed. If the system has SPT, it is call the
% hann function in the toolbox.
%
%%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3.
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%checking if SPT is installed
tmp=ver;
INSTA=0;
for n=1:length(tmp)
    if strcmp(tmp(n).Name,'Signal Processing Toolbox')
        INSTA=1;
    end
end

if INSTA
    olddir=pwd;
    cd([matlabroot,'\toolbox\signal\signal']);
    b=hann(N);
    cd(olddir);
else
    b=0.5*(1-cos(2*pi*linspace(0,N,N)/N));
    b=b';
end