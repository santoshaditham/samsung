#include "Auction.h"

Auction::Auction(int _taskno, std::string _seller){
	this->id++;
	this->taskno = _taskno;
	this->seller = _seller;
	this->tempbid = 0;
}

Auction::~Auction(){
}

void Auction::add_bid(std::string _p, double _bid){
	bids.insert(std::pair<std::string, double>(_p,_bid));
	if(this->tempbid < _bid){
		this->temp = _p;
		this->tempbid = _bid;
	} 
}

std::string Auction::get_winner(){
	this->winner = this->temp;
	return this->winner;
}

double Auction::get_winner_bid(){
	auto it = bids.find(this->winner);
	this->winner_bid = it->second;
	return this->winner_bid;
}

int Auction::get_id(){
	return this->id;
}

int Auction::get_taskno(){
	return this->taskno;
}
