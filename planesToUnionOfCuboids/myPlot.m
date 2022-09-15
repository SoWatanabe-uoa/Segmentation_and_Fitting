function myPlot(inputUnionOfCuboids_fileName, inputSetOfPlanes_fileName)
    fileID = fopen(inputUnionOfCuboids_fileName,'r');
    unionOfCuboids = fscanf(fileID, '%f', [6 Inf]);
    unionOfCuboids = unionOfCuboids';
    fclose(fileID);
    fileID = fopen(inputSetOfPlanes_fileName,'r');
    setOfPlanes = fscanf(fileID, '%f', [11 Inf]);
    setOfPlanes = setOfPlanes';
    setOfPlanes = setOfPlanes(:,2:11);
    fclose(fileID);
    
    unionOfCuboids_plot(unionOfCuboids,setOfPlanes);
end