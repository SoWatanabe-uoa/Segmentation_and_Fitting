%cleanData('cube_minus_cylinder.xyzn','cube_minus_cylinder_cleaned.xyzn');
%% 
% After running the RANSAC code ...

visualizeFittedPointCloud('cub_m_cyl.segps','c','Before DBSCAN')
visualizeFittedPointCloud('cub_m_cyl.segps','p','Before DBSCAN')
%% 
% Clustering

clustering1('cub_m_cyl.segps','cub_m_cyl_clustered1.segps',0.1,50);
clustering2('cub_m_cyl.segps','cub_m_cyl_clustered2.segps',0.1,50);
%% 
% Comparison

visualizeClusteredPointCloud('cub_m_cyl_clustered1.segps','c','Clustering1')
visualizeClusteredPointCloud('cub_m_cyl_clustered2.segps','c','Clustering2')