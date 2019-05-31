function synapse=MNNsynapse(preMN,postMN,type,synapse)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creating or updating the synapse matrix for the MN network
%Inputs:
%preMN: the ID of the pre synaptic MNs, a vector of integers;
%postMN: the ID of the post synaptic MNs, vector of inegers;
%type: type of operation: 'E': excitory; 'I': inhibitory; 'R': reset to
%zero;
%synapse: the input synapse matrix, or the number MN in the network. It should be either
%a square matrix or a integer. If the input synapse is a square matrix, it is the input matrix; 
%if it is a integer, it is the number MNs of the network.
%
%Output:
%synapse: the synapse matrix of the MN network.
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3.
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%testing if the input argument "synapse" is a integer or a square matrix
if size(synapse,1)==1
    synapse=zeros(synapse);
end

%from here on, the variable "synapse" is the synapse matrix
%Removing incorrect preMN and postMN entries, such as zero entries and
%entries that are larger than the size of the network.
preMN=sort(preMN((preMN ~= 0) & (preMN <= size(synapse,1))));
postMN=sort(postMN((postMN ~= 0) & (postMN <= size(synapse,1))));

%excitory synapses
for pre=1:length(preMN)
    synapse(preMN(pre),postMN)=1;
end

%inhibitory synapse
if type=='i'
    synapse=synapse*-1;
end

%removing existing synapse
if type=='r'
    synapse=synapse*0;
end


