#ifndef MERGE_HEADER
#define MERGE_HEADER

#include <vector>
#include <algorithm>
#include <limits>
#include <cmath>
#include <cstdlib>

#include <PointCloud.h>

// For RANSAC
#include <RansacShapeDetector.h>
#include <PlanePrimitiveShapeConstructor.h>
#include <CylinderPrimitiveShapeConstructor.h>
#include <SpherePrimitiveShapeConstructor.h>
#include <ConePrimitiveShapeConstructor.h>
#include <TorusPrimitiveShapeConstructor.h>

#include <PlanePrimitiveShape.h> // for PlanePrimitiveShape
#include <Plane.h>
#include <SpherePrimitiveShape.h>
#include <Sphere.h>
#include <CylinderPrimitiveShape.h>
#include <Cylinder.h>
#include <TorusPrimitiveShape.h>
#include <Torus.h>
#include <ConePrimitiveShape.h>
#include <Cone.h>

#include <basic.h> // for Vec3f


typedef std::vector< std::pair< MiscLib::RefCountPtr< PrimitiveShape >, size_t > > ShapeVector;
typedef MiscLib::RefCountPtr<PrimitiveShape> Primitive;

std::vector<Primitive>
MergeSimilarPrimitives(std::vector<Primitive>& primitives, float dist_thresh, float dot_thresh, float angle_thresh);


bool
ArePrimitivesClose(const Primitive& p, const Primitive& c,
	float DIST_THRESHOLD, float DOT_THRESHOLD, float ANGLE_THRESHOLD);


std::vector<Primitive>
MergeSimilarPrimitives(std::vector<Primitive>& primitives,
	float dist_thresh, float dot_thresh, float angle_thresh);


std::vector<Primitive>
MergeSimilarPrimitives(ShapeVector& primitives, float dist_thresh, float dot_thresh, float angle_thresh);


void
MergeSimilarPrimitivesFull(std::vector<Primitive>& primitives, std::vector<PointCloud>& pointClouds,
	float dist_thresh, float dot_thresh, float angle_thresh,
	std::vector<Primitive>& mergedPrimitives, std::vector<PointCloud>& mergedPointClouds);


void SplitPointsPrimitives(const ShapeVector& shapes, const PointCloud& pc, 
	std::vector<Primitive>& primitives, std::vector<PointCloud>& pointClouds);

#endif