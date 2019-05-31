function ftplot(ft,h_axes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotting the firing time plot of multiple motor units
%
% ft: the cell containing firing times of MUs
% h_axes: the handles of target axes. If not specified, creat a new
% figure
%
%Written by Ning Jiang, Institute of Biomedical Engineering, Univesity of New
%Brunswick, NB, Canada, E3B 5A3.
%Email: ning.jiang@unb.ca
%
%Date: Nov 19, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin == 1) || (h_axes == 0)
    figure;
    h_axes=gca;
end
nMU=length(ft);

cl_order=get(h_axes,'colororder');
for n=1:nMU
    cl_idx=rem(n-1,size(cl_order,1))+1;
    for m=1:length(ft{n})-1
        line(ones(1,2)*ft{n}(m),[-0.25,0.25]+n,'color',cl_order(cl_idx,:));
        line([ft{n}(m),ft{n}(m+1)],[n,n],'color',cl_order(cl_idx,:));
    end
    if ~isempty(m)
        line(ones(1,2)*ft{n}(m+1),[-0.25,0.25]+n,'color',cl_order(cl_idx,:));
    end
end


        