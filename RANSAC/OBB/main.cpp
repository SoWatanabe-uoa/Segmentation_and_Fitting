#include <algorithm>
#include <iostream>
#include <cstdio>
#include <string>
#include <cstddef>


#include "OBB_Vec3.h"
#include "OBB.h"


void computeAABB(const std::vector<OBBVec3>& pnts, OBBVec3 AABB_pnts[8]) {
  OBBVec3 minim(1e10, 1e10, 1e10), maxim(-1e10, -1e10, -1e10);
  for(size_t i=0; i<pnts.size(); i++){
      minim = minim.Min(pnts[i]);
      maxim = maxim.Max(pnts[i]);
  }
  
  // Use the same convention as in OBB::get_bounding_box()
  AABB_pnts[0] = OBBVec3(minim.x, minim.y, minim.z);
  AABB_pnts[1] = OBBVec3(maxim.x, minim.y, minim.z);
  AABB_pnts[2] = OBBVec3(maxim.x, minim.y, maxim.z);
  AABB_pnts[3] = OBBVec3(minim.x, minim.y, maxim.z);
  AABB_pnts[4] = OBBVec3(minim.x, maxim.y, minim.z);
  AABB_pnts[5] = OBBVec3(maxim.x, maxim.y, minim.z);
  AABB_pnts[6] = OBBVec3(maxim.x, maxim.y, maxim.z);
  AABB_pnts[7] = OBBVec3(minim.x, maxim.y, maxim.z);
}


void write_aabb(OBBVec3 AABB_pnts[8], const char* filename) {
  int quad[][4] = {
    { 0, 1, 2, 3 },
    { 4, 7, 6, 5 },
    { 0, 3, 7, 4 },
    { 1, 5, 6, 2 },
    { 0, 4, 5, 1 },
    { 2, 6, 7, 3 }
  };
  
  FILE *fp = fopen(filename, "w");
  for(int i=0; i<8; i++){
    fprintf(fp, "v %f %f %f\n", AABB_pnts[i].x, AABB_pnts[i].y, AABB_pnts[i].z);
  }
  
  for(int i=0; i<6; i++){
    fprintf(fp, "f %d %d %d %d\n", quad[i][0]+1, quad[i][1]+1, quad[i][2]+1, quad[i][3]+1);
  }
  
  fclose(fp);
}


// writes a wavefront .obj file for a given obb
void write_obb(OBB &obb, const char *filename){
  /*
    int quad[][4] = {
    { 0, 3, 2, 1 },
    { 4, 5, 6, 7 },
    { 0, 4, 7, 3 },
    { 1, 2, 6, 5 },
    { 0, 1, 5, 4 },
    { 2, 3, 7, 6 }
  };
  */
  int quad[][4] = {
    { 0, 1, 2, 3 },
    { 4, 7, 6, 5 },
    { 0, 3, 7, 4 },
    { 1, 5, 6, 2 },
    { 0, 4, 5, 1 },
    { 2, 6, 7, 3 }
  };

  OBBVec3 pnt[8];
  
  FILE *fp = fopen(filename, "w");
  obb.get_bounding_box(pnt);
  for(int i=0; i<8; i++){
    fprintf(fp, "v %f %f %f\n", pnt[i].x, pnt[i].y, pnt[i].z);
  }
  for(int i=0; i<6; i++){
    fprintf(fp, "f %d %d %d %d\n", quad[i][0]+1, quad[i][1]+1, quad[i][2]+1, quad[i][3]+1);
  }

  fclose(fp);
}


// parses the 1-based vertex id from a wavefront .obj file.  
int parse_vertex_id(const char *c){
  int vid;
  std::string s = c;
  std::replace(s.begin(), s.end(), '/', ' ');
  sscanf( s.c_str(), "%d", &vid );
  return vid;
}


int main(int argc, char **argv){
  OBBVec3 p;
  char line[1024], token[3][1024];
  std::vector<OBBVec3> pnts;
  std::vector<int> tris;
  
  // print out usage information if no command
  // line arguments are provided
  if(argc == 1){
    std::cout << "usage: " << argv[0] << " input.obj" << std::endl;
    return 0;
  }
  
  // read in a wavefront .obj file from the
  // first command-line argument
  FILE *fp = fopen(argv[1], "r");
  while(fgets( line, 1024, fp)){
    if(line[0] == 'v'){
      // vertex line, scan in the point coordinates
      // and add the point to the vertex array
      sscanf(line, "%*s%lf%lf%lf", &p.x, &p.y, &p.z);
      pnts.push_back(p);
    } else if(line[0] == 'f'){
      // facet line, scan in the tokens and then parse
      // add the vertex ids to the triangle index list
      sscanf(line, "%*s%s%s%s", token[0], token[1], token[2]);
      tris.push_back(parse_vertex_id(token[0])-1);
      tris.push_back(parse_vertex_id(token[1])-1);
      tris.push_back(parse_vertex_id(token[2])-1);
    }
  }
  fclose(fp);
  
  // define 3 OBB objects, and build one using just
  // the model points, one using the model triangles
  // and one using the convex hull of the model
  OBB obb_pnts;
  obb_pnts.build_from_points(pnts);
  /*
  OBB obb_tris;
  obb_tris.build_from_triangles( pnts, tris );
  */

  // print the volume of the fitted boxes, since all
  // OBBs contain the input, smaller volumes indicate
  // a tighter fit
  std::cout << "obb points volume: " << obb_pnts.volume() << std::endl;
  //std::cout << "obb tris volume: " << obb_tris.volume() << std::endl;
    
  // write the output as obj files
  write_obb(obb_pnts, "obb_points.obj");
  //write_obb( obb_tris, "obb_triangles.obj" );


  // For comparison, compute the AABB
  OBBVec3 AABB_pnts[8];
  computeAABB(pnts, AABB_pnts);
  write_aabb(AABB_pnts, "aabb_points.obj");
    
  return 0;
}
