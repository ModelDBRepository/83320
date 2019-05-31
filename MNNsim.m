function MNNsim(network,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The main simulation routine of the MN network.
%Inputs:
%network: the structure of the MN network;
%para: the structure of the simulation parameters
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%Rev. Nov 20, 2006 --> passing para to "simulation.m" routine, instead of
%duration, stepsize etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nNeuron=length(network.neurons);
%generate or load Common Input (CI) funcs that will produce common drive within
%the MN pool.

if isfield(network,'cdfunc')
    for cdfuncid=1:length(network.cdfunc)
        if network.cdfunc(cdfuncid).type == 1 
            %generate CI functions on the fly
            network.cdfunc(cdfuncid).func=gene_cdfun(network.cdfunc(cdfuncid).rms,para.stepsize,para.duration,0);
        else
            %load stored CI functions 
            load(network.cdfunc(cdfuncid).name,'func');
            network.cdfunc(cdfuncid).func=func;
        end
    end
end

%Simulation begins...
for n=1:para.trial_num
    %generate the input current to each of the MNS in the pool
    inp=zeros(para.duration*1000/para.stepsize+1,nNeuron);
    for m=1:nNeuron 
        cdfuncid=network.neurons(m).cdfuncid;
        if cdfuncid ~= 0
            %MNs that does not have CI inputs
            inp(:,m)=gene_inp(network.neurons(m).inpbias,network.neurons(m).inpsigma,...
                    para.duration,para.stepsize,network.cdfunc(cdfuncid).func);
        else
            %MNs that has CI inputs
            inp(:,m)=gene_inp(network.neurons(m).inpbias,network.neurons(m).inpsigma,...
                    para.duration,para.stepsize,0);

        end
        network.neurons(m).inp=inp(:,m);
    end % for m=1:length(handles.network.neurons)
    
           
    %generate actual firing times for the network
    simulation(network,para,inp,n,0,0);
    disp(['trial ',num2str(n),' Done!']);
end