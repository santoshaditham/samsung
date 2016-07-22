#include <string>
#include <unordered_map>
#include <list>
#include <vector>
#include <deque>
#include <algorithm>
#include <sstream>
#include "Node.h"
#include "Auction.h"
#include "Poco/Thread.h"
#include "Poco/ThreadLocal.h"

#define ADMIN_ADDR "127.0.0.1"
#define TASKS 10

class Seller: public Node
{
private:
int admin_port;
std::unordered_map<std::string, int> participants;
std::unordered_map<std::string, Poco::Thread*> recv_threads;
std::unordered_map<int, Auction*> auctions;
std::unordered_map<int, std::string> winners;
std::unordered_map<int, double> winners_bids;

public:
Seller(std::string, int);
~Seller();

void recv_admin();
void send_admin(std::string);

void add_participant(std::string);
void add_auction(int);

void send_auction_invites(int);
void recv_bids();
void conduct_auctions();
};
