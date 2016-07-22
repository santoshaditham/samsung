#include "Node.h"

int Node::recv_port = PORT+1;
Poco::ThreadLocal<int> Node::tls;

Node::Node(){
}

Node::Node(std::string _addr, int _type){
	this->address = _addr;
	this->type = static_cast<Node_Type>(_type);
        Poco::Thread *t_recv = new Poco::Thread();
        t_recv->start(*this);
}

Node::~Node(){
}

std::string Node::get_addr(){
	return this->address;
}

void Node::set_addr(std::string _addr){
	this->address = _addr;
}

int Node::get_type(){
	return static_cast<int>(this->type);
}

void Node::set_type(int _type){
	this->type = static_cast<Node_Type>(_type);
}

bool Node::send(std::string _to, int _toport, std::string _msg){
	Poco::Net::SocketAddress sa("localhost", PORT);
	Poco::Net::SocketAddress ra(_to, _toport);
	Poco::Net::DatagramSocket dgs(sa);
	dgs.sendTo(_msg.data(), _msg.length(), ra);
	std::cout << "sent from " << sa.toString() << " to " << ra.toString() << std::endl;
	return true; 
}

void Node::recv(int _port){
	Poco::Net::SocketAddress sa("localhost", _port);
	Poco::Net::DatagramSocket dgs(sa);
	
	for (;;)
	{
		if(mutex.tryLock()){
			Poco::Net::SocketAddress sender;
			char* temp;
			int n = dgs.receiveFrom(temp, sizeof(temp), sender);
			std::string msg(temp);
			std::unordered_map<std::string,std::deque<std::string>*>::iterator got = msgs.find (sender.toString());
			if (got != msgs.end())
				got->second->push_back(msg);
			else{
				std::deque<std::string> *msg_queue = new std::deque<std::string>();
				msg_queue->push_back(msg);
				msgs.insert(std::make_pair(sender.toString(), msg_queue));
			}
			std::cout << "recv from " << sender.toString() << std::endl;
		}		
		mutex.unlock();
	}
}

void Node::run(){
	if(mutex.tryLock()){
		*tls = recv_port;
		recv_port++;
		std::cout << "new thread for port " << std::to_string(*tls) << std::endl;
		recv(*tls);
	}
	mutex.unlock();
}

int Node::getTLS(){
	return *tls;
}
