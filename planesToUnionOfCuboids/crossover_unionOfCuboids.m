function xoverKids  = crossover_unionOfCuboids(parents,options,NVARS, ...
    FitnessFcn,thisScore,thisPopulation)
%   This function crossovers PARENTS to produce
%   the children XOVERKIDS.
%
%   The arguments to the function are 
%     PARENTS: Parents chosen by the selection function
%     OPTIONS: Options created from OPTIMOPTIONS
%     NVARS: Number of variables (number of cuboids)
%     FITNESSFCN: Fitness function 
%     STATE: State structure used by the GA solver 
%     THISSCORE: Vector of scores of the current population 
%     THISPOPULATION: Matrix of individuals in the current population
 

    nKids = length(parents)/2;
    xoverKids = cell(nKids,1); % Normally zeros(nKids,NVARS);
    index = 1;
    numOfCuboids = NVARS;

    for i=1:nKids
        % here is where the special knowledge that the population is a cell
        % array is used. Normally, this would be thisPopulation(parents(index),:);
        parent1 = thisPopulation{parents(index)};
        parent2 = thisPopulation{parents(index+1)};
        index = index + 2;

        % Two-point crossover of parent1 and parent2:
        % Exchange subsets of cuboids between the two creatures
        numOfCrossoveredCuboid = randi(numOfCuboids);
        p1 = ceil((6-1) * rand);%randi
        p2 = p1 + ceil((6-p1-1) * rand); %randi
        child = parent1;
        child(numOfCrossoveredCuboid,p1:p2) = parent2(numOfCrossoveredCuboid,p1:p2);
        xoverKids{i} = child; % Normally, xoverKids(i,:);
    end
end