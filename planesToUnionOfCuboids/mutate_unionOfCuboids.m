function mutationChildren = mutate_unionOfCuboids(parents ,options,NVARS, ...
    FitnessFcn, state, thisScore,thisPopulation,mutationRate)
%   This function mutates the
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

    mutationChildren = cell(length(parents),1);% Normally zeros(length(parents),NVARS);
    numOfCuboids = NVARS;

    for i=1:length(parents)
        parent = thisPopulation{parents(i)}; % Normally thisPopulation(parents(i),:)
        % Randomly select a plane in a cuboid and replace it by another plane (picked at random)
        
        % Randomly select a cuboid in a creature, and replace it by a new randomly formed cuboid
        numOfMutatedCuboid = randi(numOfCuboids);
        child = parent;
        child(numOfMutatedCuboid,:) = randsample(numOfCuboids*6,6);
        mutationChildren{i} = child; % Normally mutationChildren(i,:)
        
        % Randomly create a new creature (set of cuboids)
        
    end
end