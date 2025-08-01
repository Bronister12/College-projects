#ifndef HEALTH_DATA_H
#define HEALTH_DATA_H

#include <string>
#include <vector>


class Patient{
private:
	std::string name;
	int age;
	int id;
	std::string condition;
	std::string status;
public:
	Patient() : name("None"), id(0), condition("None"), status("None"), age(0) {}
	Patient(std::string name, std::string condition, std::string status, int age)
		: name(name), condition(condition), status(status), age(age) {}

	std::string getName() const;
	int getAge() const;
	int getID() const;
	std::string getCondition() const;
	std::string getStatus() const;
	
	void setName(std::string name);
	void setAge(int age);
	void setID(int id);
	void setCondition(std::string condition);
	void setStatus(std::string status);
	void printInfo() const;
};

class Console{
private:
	std::vector<Patient> patients;
	std::vector<int> IDs;
public:
	Console() = default;
	
	void addPatient(Patient p);
	void listPatients();
	Patient* searchByName(std::string name);
	void deleteByID(int id);
	void generateID(Patient &p);
	void saveToFile(const std::string& filename) const;
	void loadFromFile(const std::string& filename);

};

#endif
