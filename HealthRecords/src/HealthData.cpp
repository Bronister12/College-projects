#include "HealthData.h"
#include <nlohmann/json.hpp>
#include <iostream>
#include <cstdlib>
#include <fstream> 
#include <iomanip>
using nlohmann::json;

// Patient to Json	
void to_json(json& j, const Patient& p) {
	j = json{
		{"name", p.getName()},
		{"age", p.getAge()},
		{"id", p.getID()},
		{"condition", p.getCondition()},
		{"status", p.getStatus()}
	};
}

// Json to Patient
void from_json(const json& j, Patient& p){
	p.setName(j.at("name").get<std::string>());
	p.setAge(j.at("age").get<int>());
	p.setID(j.at("id").get<int>());
	p.setCondition(j.at("condition").get<std::string>());
	p.setStatus(j.at("status").get<std::string>());
}



std::string Patient::getName() const{
	return name;
}

int Patient::getAge() const {
	return age;
}

int Patient::getID() const{
	return id;
}

std::string Patient::getCondition() const{
	return condition;
}

std::string Patient::getStatus() const{
	return status;
}

void Patient::setName(std::string name){
	this->name = name;
}

void Patient::setAge(int age){
	this->age = age;
}

void Patient::setID(int id){
	this->id = id;
}

void Patient::setCondition(std::string condition){
	this->condition = condition;
}

void Patient::setStatus(std::string status){
	this->status = status;
}

void Patient::printInfo() const {
	std::cout << "Name: " << name << "\n"
		<< "Age: " << age << "\n"
		<< "ID: " << id << "\n"
		<< "Condition: " << condition << "\n"
		<< "Status: " << status << "\n\n";
}


// Console
void Console::addPatient(Patient p){
	generateID(p);
	std::string name = p.getName();
	bool insert = false;
	int i = 0;
	for(auto& patient : patients){
		if(!insert && (patient.getName() > name)){
			patients.insert(patients.begin() + i, std::move(p));
			insert = true;
		}
		++i;
	}
	if(!insert){
		patients.emplace_back(p);
	}
}

void Console::listPatients(){
	for(auto it = patients.begin(); it != patients.end(); ++it){
		it->printInfo();
	}
}

Patient* Console::searchByName(std::string name){
	int left = 0, right = patients.size() -1, mid;
	std::string midName;
	while(left <= right){
		mid = (left+right)/2;
		midName = patients[mid].getName();
		if(midName == name){
			return &patients[mid];
		}
		else if(midName < name){
			left = mid + 1;
		}else{
			right = mid -1;
		}

	}
	std::cout << "Patient with such name was not found." << "\n";
	return nullptr;
}

void Console::deleteByID(int id) {
	for(auto it = patients.begin(); it != patients.end();){
		if(it->getID() == id) {
			std::cout << "Patient " << it->getName() << " erased.\n";
			patients.erase(it);
			return;
		}else{
			++it;
		}
	}
}

void Console::generateID(Patient &p){
	bool match;
	do{
		match = false;
		p.setID(rand() %999 +1);
		for(auto it = IDs.begin(); it != IDs.end(); ++it){
			if(p.getID() == *it){
				match = true;
				break;
			}
		}
	}while(match);
	IDs.push_back(p.getID());
}

void Console::saveToFile(const std::string& filename) const {
	json j = patients;
	std::ofstream out{filename};
	out << std::setw(4) << j;
}

void Console::loadFromFile(const std::string& filename){
	std::ifstream in{filename};
	if(!in){
		std::cerr << "Cannot open" << filename << "\n";
		return;
	}
	json j;
	in >> j;
	patients.clear();
	IDs.clear();
	for(const auto& item : j){
		patients.push_back(item.get<Patient>());
		IDs.push_back(patients.back().getID());
	}
}
	

