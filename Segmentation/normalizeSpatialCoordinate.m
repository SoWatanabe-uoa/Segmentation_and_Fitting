function pcout = normalizeSpatialCoordinate(pc)
%Normalize the spatial coordinates such that the objects fits inside the unit box centered at the origin
    %Calculate the center of mass
    center = [mean(pc(:,1)), mean(pc(:,2)), mean(pc(:,3))];
    %Translate all points such that the center of mass is at the origin
    pc_translated = [pc(:,1)-center(1,1), pc(:,2)-center(1,2), pc(:,3)-center(1,3)];
    %Divide each coordinate by the length of the maximum side length of the point-cloud bounding box
    ptCloud = pointCloud(pc_translated);
    side_len_max = max([ptCloud.XLimits(1,2) - ptCloud.XLimits(1,1), ptCloud.YLimits(1,2) - ptCloud.YLimits(1,1), ptCloud.ZLimits(1,2) - ptCloud.ZLimits(1,1)]);
    pc_normalized = pc_translated ./ side_len_max;
    pcout = [pc_normalized, pc(:,4:8)];
end