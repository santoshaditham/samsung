OBJS = Main.o Seller.o Node.o Auction.o
CC = clang++
CFLAGS = -Wall -std=c++11 -stdlib=libc++ -c
LFLAGS = -Wall -lPocoUtil -lPocoNet -lPocoXML -lPocoFoundation

seller : $(OBJS)
	$(CC) $(OBJS) $(LFLAGS) -o seller
 
Main.o: Main.cpp Seller.h
	$(CC) $(CFLAGS) Main.cpp     
 
Seller.o: Seller.cpp Seller.h Node.h Auction.h
	$(CC) $(CFLAGS) Seller.cpp
 
Node.o: Node.cpp Node.h
	$(CC) $(CFLAGS) Node.cpp

Auction.o: Auction.cpp Auction.h
	$(CC) $(CFLAGS) Auction.cpp

clean:
	\rm *.o *~ seller
