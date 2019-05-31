%Instruction of using Motor uNit INnervation process Generator
%(mNing) to simulate the innervation process of a pool of motoneurons
%The package is written in an object oriented fashion. Two main data
%structures are used: "network" and "para". 
%
%The first top-level structure "Network" is the structure
%containing various parameters of the motoneuron pools. Three sub-structure
%exists within "network": 
%1) neurons: the individual neurons. Neurons itself is also a structure,
%and its fields are the various parameters in the HH model, such as the
%contances of potassium, sodium, and leak current, the reversal potential,
%etc. There are several fields that are of particular interest within this
%simulation context.
%   a) vna: the reversal potential of Na+. it determins the recruitment
%   threshold of the neuron. The larger this value, the lower the
%   recruitment threshold.
%   b) inpbias: the bias current, or base current of the neuron. Determines
%   the mean firing rate of the neuron. 
%   c) inpsigma: the STD of the input current. Determines the variance of
%   the firing rate of the neuron.
%   d) cdfuncid: The type of Common Input (CI) to the neuorn. This field is
%   an integer (an ID), which corresponds to one of the Common Input
%   functions defined in "network.cdfunc". If it is 0, then there is no CI
%   to this neuron.
%   e) inp: the input current to this neuron. This will be generated during
%   the simulation using related parameters by the runtine called
%   "gene_inp.m"
%
% 
%2) synapse: the synapse matrix of the network. Generate by routine "MNNsynapse.m";
%
%
%3) cdfunc: the common input function that is responsible for the COMMON
%DRIVE effect within the MN pool. Itself is alos a structure array with the
%following fields:
%   a)  type: an integer that determines the type, 1 means generate on the
%   fly; 2 means using a stored data;
%   b)  rms: the rms value of the CI function. it should be zero if "type"
%   is set to 2;
%   c)  name: the full path of the stored data file;
%   d)  func: the CI function. This will be generate by the routine
%   "gene_cdfun.m"
%
%
%The second top-level structure "para" is the structure containing various simulation parametres:
%1) duration: the duration of the simulation, in sec
%2) stepsize: the stepsize of the ODE solver, in msec
%3) trial_num: repeatation of simulations
%4) resultfilepath: the path where to store the simulation results
%5) resultfilename: the common file name for the simulation result files
%
%

%This is a sample script of using the various functions in mNing package to
%simulate a MN pool of 11 MNs. In this pool, MN(1) is the common excitor
%for the other 10 MNs. MN(2:6) and MN(7:11) are two MN groups, each have a
%CI of their own. There is a recruitment order within each of the group.
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3.
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Loading neuron template 
%loading template
%load([matlabroot,'\work\mNing\data\neuron\','template.mat']);
load template.mat;
template=neurons;
template.inpbias=10;
template.inpsigma=2;
network.neurons=template;
clear neurons;
%%  Creating the "neuron" structure
%size of the pool
nMN=11;
%range of Vna--->range of recruitment level
max_vna=80;
min_vna=20;
%creating MN objects in a batch model. The common excitor is set to have
%the lowest recruitment threshold.
network.neurons(1).vna=80;
%The first group MN(2:6)
network.neurons(2:6)=batchMNN(5,template,max_vna,min_vna,'linear');
%The second group MN(7:11)
network.neurons(7:11)=batchMNN(5,template,max_vna,min_vna,'linear');
%%  Creating the synaptic matrix
%preMN=(1:4);
%postMN=(5:10);
preMN=1;
postMN=(2:11);
network.synapse=MNNsynapse(preMN,postMN,'e',length(network.neurons));
%Updating the ODE functions. This should be done when ever the network
%structure changes, such as parameter changes in any of the "neurons"
%substructure, or the synapse matrix. However, the changes of CI functions
%does not necessarily mean an update of "simulation", since it is not a
%"structrual change"
generate_ode(network.neurons,network.synapse);
%%  Defining CD functions
%number of CD functions
nCD=2;
%creating the sub-structure of 'cdfun' for later use
% .type: is the type of cdfuns --> 1: created On the fly during simulation.
%                                     it requires non zero value of the field 'rms'; 
%                                  2: use saved funcs. it requires the field 'name' 
%                                     to be a valid pathname/filename
%
% .rms: the rms value of the CD fun. if type is 1; it is 0 if type is 2;
% .name: the path/filename of the stored cdfun data if type is 1; "N/A" if type
% is 1
%
for n=1:nCD
    network.cdfunc(n).type=1;
    network.cdfunc(n).rms=2;
    network.cdfunc(n).name='N/A';
end
%Or if pre-stored CI data is to be used:
% network.cdfunc.type=2;
% network.cdfunc.rms=0;
% network.cdfunc.name=[matlabroot,'\work\mNing\data\cidata\testfunc'];
%
%Assigning the CI func IDs to individual MNs; the field "cdfunid" in each
%neuron corresponds to the field "cdfunc" in network. If "cdfuncid" is zero,
%meaning there is no cdfun to that neuron. If "cdfuncid" is some non-zero
%number N, meaning the CI func to this neuron is the the cdfun number N.
%
%In this example, MN(2:6) have a CI func ID of 1, and MN(7:11) have a CI func ID of 2:
assigncd=[0,ones(1,5),ones(1,5)*2];
%assigncd=ones(1,nMN); %all have the same CI function
%assigncd=zeros(1,nMN); %no CI functions at all
for n=1:nMN
    network.neurons(n).cdfuncid=assigncd(n);
end
%%  Setting up simulation parameters
%the integration stepsize for the ODE solver, in msec
para.stepsize=5;
%duration of simulation, in sec
para.duration=10;
%number trials;
para.trial_num=1;
%full path of result data
%para.resultfile=[matlabroot,'\work\mNing\data\result\11n_2cdfunc'];
para.resultfile='result\11n_2cdfunc';
%%  begin simulation
MNNsim(network,para);
%%  Displaying the simulation results
load([para.resultfile,'_1']);
% The input currents to each MN
plotmulti(iinp,1/para.stepsize);
% The firing times of each MN
ftplot(firing_t,0);