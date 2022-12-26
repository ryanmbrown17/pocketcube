FLAGS =  -Wall -g 
CC = g++
OBJECTS = 

a.out:  cube_real.cpp
	$(CC) $(FLAGS) $(OBJECTS)  -o a.out cube_real.cpp
clean:
	-rm  a.out $(OBJECTS)
