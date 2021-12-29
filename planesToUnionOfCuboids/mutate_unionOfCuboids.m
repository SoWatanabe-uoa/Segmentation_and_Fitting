function mutationChildren = mutate_unionOfCuboids(parents ,options,NVARS, ...
    FitnessFcn, state, thisScore,thisPopulation,mutationRate)
%   MUTATE_PERMUTATION Custom mutation function for traveling salesman.
%   MUTATIONCHILDREN = MUTATE_PERMUTATION(PARENTS,OPTIONS,NVARS, ...
%   FITNESSFCN,STATE,THISSCORE,THISPOPULATION,MUTATIONRATE) mutate the
%   PARENTS to produce mutated children MUTATIONCHILDREN.
%
%   The arguments to the function are 
%     PARENTS: Parents chosen by the selection function
%     OPTIONS: Options created from OPTIMOPTIONS
%     NVARS: Number of variables 
%     FITNESSFCN: Fitness function 
%     STATE: State structure used by the GA solver 
%     THISSCORE: Vector of scores of the current population 
%     THISPOPULATION: Matrix of individuals in the current population
%     MUTATIONRATE: Rate of mutation


    % Here we swap a plane of a cuboid and a plane of another cuboid in
    % each creature(union of cuboids)
    mutationChildren = cell(length(parents),1);% Normally zeros(length(parents),NVARS);
    for i=1:length(parents)
        parent = thisPopulation{parents(i)}; % Normally thisPopulation(parents(i),:)
        cuboids = 1:size(parent,1);
        if(numel(cuboids) > 1)
            picked_cuboids = randsample(cuboids, 2); % Pick 2 cuboids at random
            p = randi(6);
            child = parent;
            child(picked_cuboids(1),p) = parent(picked_cuboids(2),p);
            child(picked_cuboids(2),p) = parent(picked_cuboids(1),p);
            mutationChildren{i} = child; % Normally mutationChildren(i,:)
        end
    end
end