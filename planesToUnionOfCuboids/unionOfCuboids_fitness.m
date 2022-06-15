function scores = unionOfCuboids_fitness(x,num_point,SDF)
%   This function calculates the fitness 
%   of an creature (cuboid). The fitness is the total signed distance between a
%   given point and one cuboid.

    scores = zeros(size(x,1),1);
    for j = 1:size(x,1)
        % here is where the special knowledge that the population is a cell
        % array is used. Normally, this would be pop(j,:);
        unionOfCuboids = x{j};
        %disp('Creature')
        %disp(unionOfCuboids)
        f = 0.0;
        for i = 1:num_point
            f = f + exp(-1*SDF(i,unionOfCuboids));
            % Later: Consider whether orthogonal 
        end
        %disp(f)
        scores(j) = -f;
    end
end