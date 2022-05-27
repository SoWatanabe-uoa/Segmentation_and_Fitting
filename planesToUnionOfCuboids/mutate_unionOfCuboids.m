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

    alpha = 0.4; % Probability that the 1st process is done
    beta = 0.3; % Probability that the 2nd process is done
    % gumma = 1-alpha-beta : Probability that the 3rd process is done

    mutationChildren = cell(length(parents),1);% Normally zeros(length(parents),NVARS);
    numOfCuboids = NVARS;

    for i=1:length(parents)
        parent = thisPopulation{parents(i)}; % Normally thisPopulation(parents(i),:)
        probability = rand; % Probability that one out of the following 3 processes is done
        
        % Randomly select a plane in a cuboid and replace it by another plane (picked at random)
        if(0 < probability && probability < alpha)
            indexOfMutatedCuboid = randi(numOfCuboids);
            indexOMutatedPlane = randi(6);
            child = parent;
            child(indexOfMutatedCuboid,indexOMutatedPlane) = randsample(numOfCuboids*6,1);
            mutationChildren{i} = child; % Normally mutationChildren(i,:)
        
        % Randomly select a cuboid in a creature, and replace it by a new randomly formed cuboid
        elseif(alpha < probability && probability < (alpha+beta))
            indexOfMutatedCuboid = randi(numOfCuboids);
            child = parent;
            child(indexOfMutatedCuboid,:) = randsample(numOfCuboids*6,6);
            mutationChildren{i} = child; % Normally mutationChildren(i,:)
        
        % Randomly create a new creature (set of cuboids)
        elseif((alpha+beta) < probability && probability < 1)
            newUnionOfCuboids = zeros(numOfCuboids,6);
            for j = 1:numOfCuboids
                unionOfCuboids(j,:) = randsample(numOfCuboids*6,6); 
            end
            mutationChildren{i} = newUnionOfCuboids; % Normally mutationChildren(i,:)
        end
    end
end