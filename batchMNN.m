function neurons=batchMNN(nMN,template,max_vna,min_vna,option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creating a pool of motoneuron in a batch fashion. 
%The model of the motoneuron pool is described in:
%A.J. Fuglevand, et. al. Models of Recruitment and rate coding organization
%in Motor unit pools, J of neurophsiology, vol 70, No.6, 1993, 2471~2488
%nMN: number of neurons;
%
%template: the template containing the parameters of a typical neuron;
%max_vna: maximum Vna for the neuron pool, which will be recruited first (lowest recruitment threshold);
%min_vna: minimum Vna for the neuron pool, which will be recruited last (highest recruitment threshold);
%option: method of assigning Vna across the pool: 'exp' meaning assigning
%exponentially, more neurons will have larger Vna, and fewer neurons will
%have large Vna. So, more motoneurons will have lower recuirtment threshold, with fewer having high recruitment 
%threshold; 'linear' means that Vna of the MNs in the pool will be 
%uniformly distributed.
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3.
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%Rev. 1.1, Nov 20 ---> changed the reverse order of Vna when option=linear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(option, 'exp')
    a=log(max_vna-min_vna)/nMN;
    VNA=max_vna-exp(a*(1:nMN));
else
    VNA=linspace(max_vna,min_vna,nMN);
end
neurons = repmat(template,1,nMN);
for n=1:nMN
    neurons(n)=template;
    neurons(n).vna=VNA(n);
end