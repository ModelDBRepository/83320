function generate_ode(neurons,synapses)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This is the function that generate the ODE file "simulation.m" based on
%the parameters of the MN network to be simulated. It reads the two input
%parameters which described below, and generate the ODE system
%accordingly (the string variable "str"). Then it opens a .m file called
%"simulation_bk.m", which is a template of the ODE function. It places
%"str" at the end of the template function, and save it as a new file named
%"simulation.m". This is the file to be used in further simulations.
%Inputs
%neurons: the structure array of each MN in the network
%synapses: the synapses matrix of the network.
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3.
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% creating the ODE system according to the two input parameters.
num_of_neurons = length(neurons);
if num_of_neurons > 0
    str = ['dydt=['];

    for post=1:num_of_neurons
        syn_str=[];
        post_col=(post-1)*3;
        for pre=1:num_of_neurons
            pre_col=(pre-1)*3;
            switch synapses(pre,post)
                case 1
                    syn_str=[syn_str,'-',num2str(neurons(post).gsyn),'*','y(',num2str(pre_col+3),...
                        ')*(y(',num2str(post_col+1),')-',num2str(neurons(post).vsyne),')'];
                case -1
                    syn_str=[syn_str,'-',num2str(neurons(post).gsyn),'*','y(',num2str(pre_col+3),...
                        ')*(y(',num2str(post_col+1),')-',num2str(neurons(post).vsyni),')'];
            end
        end
                        
        str = [str,'-(',num2str(neurons(post).gl),'*(y(',num2str(post_col+1),')-',num2str(neurons(post).vl),...
            ')+',num2str(neurons(post).gna),'/(1+exp(-(y(',num2str(post_col+1),')+',num2str(neurons(post).thetam),')/',...
            num2str(neurons(post).sm),'))^3*(0.5-y(',num2str(post_col+2),'))*(y(',num2str(post_col+1),')-',num2str(neurons(post).vna),')',...
            '+',num2str(neurons(post).gk),'*y(',num2str(post_col+2),')^4*(y(',num2str(post_col+1),')-',num2str(neurons(post).vk),'))',...
            '+inp(',num2str(post),')',syn_str,';\n',...
            num2str(neurons(post).phi),'*(1/(1+exp((y(',num2str(post_col+1),')-',num2str(neurons(post).thetan),')/',...
            num2str(neurons(post).sn),'))-y(',num2str(post_col+2),'))/(',num2str(neurons(post).taun0),'+',num2str(neurons(post).taun1),...
            '/(1+exp((y(',num2str(post_col+1),')-',num2str(neurons(post).thn),')/',num2str(neurons(post).sigman),')));\n',...
            num2str(neurons(post).alpha),'*(1-y(',num2str(post_col+3),'))*(1/(1+exp(-(y(',num2str(post_col+1),')-',...
            num2str(neurons(post).thetas),')/',num2str(neurons(post).ks),')))-',num2str(neurons(post).beta),'*y(',num2str(post_col+3),');\n\n\n'];
        
        
    end
    str = [str '];'];
end
%open "simulation_bk.m"
fid_bk=fopen('simulation_bk.m','r');

%Read the contents of "simulation_bk.m", stored it in "main_str"
main_str=[];
flag=fgets(fid_bk);
while ischar(flag)
    main_str=[main_str,flag];
    flag=fgets(fid_bk);
end
fclose(fid_bk);

%concatenate "str" to the end of "main_str", and write the new file
%"simulation.m"
main_str=[main_str,str];
fid=fopen('simulation.m','w');
fprintf(fid,main_str);
fclose(fid);