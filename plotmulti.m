function plotmulti(signal,sf,section)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotting multiple data trace in one view. Some bias were added to each of
%the trace.
%input:
%signal: the signal to be plotted. Each column is a trace.
%sf: the sampleing rate, in kHz
%section: the section to be display, in sec.
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3.
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('sf')
    sf=1; %in kHz
end

s=size(signal);
if s(1)>s(2)
    nSig=s(2);
    lSig=s(1);
else
    nSig=s(1);
    lSig=s(2);
end

if ~exist('section')
    section=[1,lSig];
else
    section=section*sf*1000;
end

m=max(max(signal))*1.5;

bias=repmat((1:nSig)*m,lSig,1);
signal=signal+bias;
if s(1)>s(2)
    plot(signal);
else
    plot(signal');
end

set(gca,'xlim',section,'xtick',linspace(section(1),section(2),11),'xticklabel',...
    linspace(section(1),section(2),11)/sf/1000,'ytick',(1:nSig)*m,'yticklabel',(1:nSig));
