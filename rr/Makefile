OBJS = Node.o
CC = g++
CFLAGS = -g -Wall -I~/Poco/include/ -std=c++0x -c
LFLAGS = -Wall -L~/Poco/lib/ -lPocoUtil -lPocoNet -lPocoXML -lPocoFoundation

rr : $(OBJS)
	$(CC) $(OBJS) $(LFLAGS) -o rr
 
Node.o: Node.cpp
	$(CC) $(CFLAGS) Node.cpp

clean:
	\rm *.o *~ rr
