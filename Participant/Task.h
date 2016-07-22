#include <string>
#include <fstream>
#include "Poco/Thread.h"
#include "Poco/RunnableAdapter.h"
#include "Poco/Timestamp.h"
#include <ctime>

#define CPU_TASK ""
#define IO_TASK ""

class Task{
private:
int id;
bool cpubound;
std::string script;
Poco::Thread t;
signed long runtime;
static bool alternate;

public:
Task(int);
~Task();

void run(std::string);
void start();

};
