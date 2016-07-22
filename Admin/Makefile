OBJS = Main.o Admin.o Node.o
CC = clang++
CFLAGS = -Wall -std=c++11 -stdlib=libc++ -c
LFLAGS = -Wall -lPocoUtil -lPocoNet -lPocoXML -lPocoFoundation

scheduler : $(OBJS)
	$(CC) $(OBJS) $(LFLAGS) -o scheduler
 
Main.o: Main.cpp Admin.h
	$(CC) $(CFLAGS) Main.cpp     
 
Admin.o: Admin.cpp Admin.h Node.h
	$(CC) $(CFLAGS) Admin.cpp
 
Node.o: Node.cpp Node.h
	$(CC) $(CFLAGS) Node.cpp

clean:
	\rm *.o *~ scheduler
