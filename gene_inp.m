function inp=gene_inp(iapp,stdin,duration,step_size,cdfun)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This routine generate the inp current to a MN in the network.
%inputs:
%iapp: individual input mean (bias current, or base current)
%stdin: individual input standard deviation
%step_size: step_size of the ODE solver
%cdfun: common drive func
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filter_len=16;
%put a limit on the possible value of inp current
SCALING=1;
%maximum inp current value
inp_inf=30;


b=hann(filter_len);
b=b/sum(b);
rstd=stdin/sqrt(sum(b.^2));
inp=randn(1,duration*1000/step_size+filter_len+1)*rstd+iapp;
inp=filter(b,1,inp);
inp=inp(filter_len+1:length(inp));
inp=inp+cdfun;
%limiting the input current
if SCALING
    inp=30*tanh(inp/inp_inf);
end
    