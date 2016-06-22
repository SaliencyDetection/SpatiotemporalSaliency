function Spatial = Spatial_refinement(sal, Sp)
% Jiwhan Kim, Dongyoon Han, Yu-Wing Tai, Junmo Kim,
% "Salient Region Detection via High-Dimensional Color Transform", 
% CVPR 2014

sal = im2double(sal);
label = unique(Sp);
N_Sp = length(label);
Locations = zeros(N_Sp,2);
for i = 1 : N_Sp
   [x, y] = find(Sp==label(i));
   Locations(i,1) = mean(x) / size(sal,1);
   Locations(i,2) = mean(y) / size(sal,2);
   sal_sp(i) = mean(sal(Sp==label(i)));
end

newfore = find(sal_sp >= 0.7);
newback = find(sal_sp <= 0.1);

% if no region exceeds 0.7
if length(newfore) <= 1    
	[bb, aa] = sort(sal_sp, 'descend');
	newfore = [aa(1); aa(2)];
end
        
Spatial = zeros(size(sal,1), size(sal,2));
for i = 1 : N_Sp
	foretemp = setdiff(newfore,i);  
    backtemp = setdiff(newback,i);  
	foredist = sqrt(min(dist(Locations(i,1),Locations(foretemp(:),1)').^2 + dist(Locations(i,2),Locations(foretemp(:),2)').^2));
	backdist = sqrt(min(dist(Locations(i,1),Locations(backtemp(:),1)').^2 + dist(Locations(i,2),Locations(backtemp(:),2)').^2));
	Spatial = Spatial + (Sp==label(i))*exp(-0.5*foredist / (backdist));
end
Spatial = mat2gray(Spatial);

end