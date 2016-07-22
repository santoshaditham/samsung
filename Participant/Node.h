#include "Poco/Thread.h"
#include "Poco/ThreadLocal.h"
#include "Poco/Runnable.h"
#include "Poco/Net/DatagramSocket.h"
#include "Poco/Mutex.h"
#include "Poco/Net/SocketAddress.h"
#include <iostream>
#include <string>
#include <deque>
#include <unordered_map>
#define PORT 8576

class Node: public Poco::Runnable
{

enum Node_Type{
ADMIN,
SELLER,
PARTICIPANT
};

protected:
	std::string address;
	Node_Type type;
	std::unordered_map<std::string, std::deque<std::string>*> msgs;
	Poco::FastMutex mutex;
	static int recv_port;
	static Poco::ThreadLocal<int> tls;
public:
	Node();
	Node(std::string, int);
	~Node();

	std::string get_addr();
	void set_addr(std::string);

	int get_type();
	void set_type(int);

	bool send(std::string, int, std::string);
	void recv(int);
	virtual void run();
	int getTLS();
};	
