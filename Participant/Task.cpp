#include "Task.h"

bool Task::alternate = true;

Task::Task(int _id){
	this->id = id;
	if(alternate){
		this->cpubound = true;
		this->script = CPU_TASK;
		alternate = false;
	}
	else{
		this->cpubound = false;
		this->script = IO_TASK;
		alternate = true;
	}
}

Task::~Task(){
}

void Task::run(std::string _host){
	Poco::RunnableAdapter<Task> runnable(*this, &Task::start);
	Poco::Timestamp now; 
	t.start(runnable);
	t.join();
	Poco::Timestamp::TimeDiff diff = now.elapsed();
	this->runtime = diff;
	//log
	std::ofstream myfile ("tasklog.txt", std::ios::app);
  	if (myfile.is_open())
  	{
    		myfile << "Task number: " << this->id << "\n";
    		myfile << "Execution Time: " << this->runtime << "\n";
    		myfile.close();
  	}
}

void Task::start(){
	//run the script
}
