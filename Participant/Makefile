OBJS = Main.o Participant.o Node.o Task.o
CC = clang++
CFLAGS = -Wall -std=c++11 -stdlib=libc++ -c
LFLAGS = -Wall -lPocoUtil -lPocoNet -lPocoXML -lPocoFoundation

participant : $(OBJS)
	$(CC) $(OBJS) $(LFLAGS) -o participant
 
Main.o: Main.cpp Participant.h
	$(CC) $(CFLAGS) Main.cpp     
 
Participant.o: Participant.cpp Participant.h Node.h Task.h
	$(CC) $(CFLAGS) Participant.cpp
 
Node.o: Node.cpp Node.h
	$(CC) $(CFLAGS) Node.cpp

Task.o: Task.cpp Task.h
	$(CC) $(CFLAGS) Task.cpp

clean:
	\rm *.o *~ participant
