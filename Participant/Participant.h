#include <string>
#include <sstream>
#include <deque>
#include <fstream>
#include <algorithm>
#include "Node.h"
#define TASKS 10

class Participant: public Node
{
private:
double power, voltage, current, memory, loadAvg;
double bid;
std::string seller;
int seller_port;
std::deque<int> auctions;

public:
Participant(std::string, int);
~Participant();

void recv_invite();
void send_bid(int);
void calculate_bid();
};
