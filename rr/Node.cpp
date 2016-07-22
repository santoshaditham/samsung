#include "Poco/ThreadPool.h"
#include "Poco/Thread.h"
#include "Poco/ThreadLocal.h"
#include "Poco/Runnable.h"
#include "Poco/Mutex.h"
#include "Poco/Net/ServerSocket.h"
#include "Poco/Net/StreamSocket.h"
#include "Poco/Net/SocketAddress.h"
#include <iostream>
#include <sstream>
#include <string>
#include <deque>
#define DEFAULT_PORT 10000
#define MY_ADDR "10.250.3.1"
#define ADMIN_ADDR "10.250.3.10"

class Node: public Poco::Runnable
{

protected:
	Poco::Mutex mutex;
        std::string address;
        std::deque<std::string> msgs;
public:
        Node();
	~Node();
	virtual void run();
	void recv();
	void execute();
	int do_task(int);
};

Node::Node(){
	address = MY_ADDR;
}

Node::~Node(){
}

void Node::run(){
        std::string t_name = Poco::Thread::current()->getName();
        switch(t_name[0]){
                case 'R':recv(); break;
                case 'E':execute(); break;
	}
}

void Node::recv(){
	//connect with admin
        Poco::Net::SocketAddress admin(ADMIN_ADDR, DEFAULT_PORT);
        Poco::Net::StreamSocket* admin_socket = new Poco::Net::StreamSocket(admin);
        std::cout << "connected to admin " << admin.toString() << std::endl;
        for (;;)
        {
                char* temp = new char[1];
                std::string str, msg;
                while(*temp != ';'){
                        admin_socket->receiveBytes(temp, 1);
                        std::string temp_s(temp);
                        str += temp_s;
                }
                delete(temp);
                unsigned found = str.find_last_of(";");
                msg = str.substr(0,found);
                std::cout << "yay! recvd something from admin: " << msg << std::endl;
                mutex.lock();
		msgs.push_back(msg);
		mutex.unlock();
        }
}	

void Node::execute(){	
	while(1){
		//execute tasks from admin
		if(!msgs.empty()){
			mutex.lock();
			std::string msg = msgs.front();
			msgs.pop_front();
			mutex.unlock();
			if(msg == "STOP")
				break;
			else
				do_task(1);
		}
	}
}

int Node::do_task(int task){
	if(task == 1)
		std::cout << "io" << std::endl;	
	else
		std::cout << "file" << std::endl;
	return 0;
}

int main(){
	Node *n = new Node();
        Poco::ThreadPool pool;
        pool.start(*n,"RECV");
        pool.start(*n,"EXECUTE");
        std::cout << "all threads started exec" << std::endl;
        pool.joinAll();
        std::cout << "all threads completed exec" << std::endl;
        delete(n);
	return 0;
}
