function pcout = append_onehotdecoded(pc)
% Assume that pc has size n x 12, where columns 7-11 is for the primitive type
% and column 12 for a label. 
% Assume that primitive types are numbers in {0,1,2,3,4}. 
%
nrow = size(pc, 1);
p0 = logical(pc(:,7));
p1 = logical(pc(:,8));
p2 = logical(pc(:,9));
p3 = logical(pc(:,10));
p4 = logical(pc(:,11));
pid = zeros(nrow,1);
pid(p0) = 0;
pid(p1) = 1;
pid(p2) = 2;
pid(p3) = 3;
pid(p4) = 4;
pcout = [pc(:,1:6), pid, pc(:,12)];
end