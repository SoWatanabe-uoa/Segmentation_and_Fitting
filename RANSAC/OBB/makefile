CXXFLAGS=-O3 -W -Wall
CXXFLAGS_DBG=-g -W -Wall

all: test_obb

test_obb: main.o eig3.o
	g++ -o test_obb main.o eig3.o

main.o: main.cpp OBB.h OBB_Vec3.h
	g++ $(CXXFLAGS) -c main.cpp

eig3.o: eig3.cpp eig3.h
	g++ $(CXXFLAGS) -c eig3.cpp

clean:
	rm -f *.o *.h~ *.cpp~ test_obb
