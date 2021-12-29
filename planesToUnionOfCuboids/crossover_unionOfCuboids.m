function xoverKids  = crossover_unionOfCuboids(parents,options,NVARS, ...
    FitnessFcn,thisScore,thisPopulation)
%   CROSSOVER_PERMUTATION Custom crossover function for traveling salesman.
%   XOVERKIDS = CROSSOVER_PERMUTATION(PARENTS,OPTIONS,NVARS, ...
%   FITNESSFCN,THISSCORE,THISPOPULATION) crossovers PARENTS to produce
%   the children XOVERKIDS.
%
%   The arguments to the function are 
%     PARENTS: Parents chosen by the selection function
%     OPTIONS: Options created from OPTIMOPTIONS
%     NVARS: Number of variables 
%     FITNESSFCN: Fitness function 
%     STATE: State structure used by the GA solver 
%     THISSCORE: Vector of scores of the current population 
%     THISPOPULATION: Matrix of individuals in the current population
 

    nKids = length(parents)/2;
    xoverKids = cell(nKids,1); % Normally zeros(nKids,NVARS);
    index = 1;

    for i=1:nKids
        % here is where the special knowledge that the population is a cell
        % array is used. Normally, this would be thisPopulation(parents(index),:);
        parent = thisPopulation{parents(index)};
        index = index + 2;

        % Two-point crossover of parent1:
        % Pick 2 cuboids at random and swap some planes of the 2 cuboids).
        cuboids = 1:size(parent,1);
        if(numel(cuboids) > 1)
            picked_cuboids = randsample(cuboids, 2);
            p1 = ceil((6-1) * rand);
            p2 = p1 + ceil((6-p1-1) * rand);
            child = parent;
            child(picked_cuboids(1),p1:p2) = parent(picked_cuboids(2),p1:p2);
            child(picked_cuboids(2),p1:p2) = parent(picked_cuboids(1),p1:p2);
            xoverKids{i} = child; % Normally, xoverKids(i,:);
        end
    end
end