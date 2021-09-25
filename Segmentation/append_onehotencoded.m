function pcout = append_onehotencoded(pc)
% Assume that pc has size n x 8, where columns 7 is for the primitive type
% and column 8 for a label. 
% Assume that primitive types are numbers in {0,1,2,3,4}. 
%
nrow = size(pc, 1);
r = zeros(nrow, 5);
t = pc(:, 7); % primitive type
t = t + 1; % matlab idx are starting from 1
idx = sub2ind(size(r), (1:numel(t)).', t);
r(idx) = 1.0;
pcout = [pc(:,1:6), r];
end