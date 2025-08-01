#include "HealthData.h"
#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

int main() {
	std::srand(std::time(0));
	Console console;
	try {
		console.loadFromFile("patients.json");
		} catch(...) {
		std::cout << "Start from scratch";
	}

	bool running = true;
	while (running) {
		std::cout
			<< "Health Records Menu\n"
			<< "(1) Add new patient\n"
			<< "(2) List all patients\n"
			<< "(3) Find patient by name\n"
			<< "(4) Delete patient\n"
			<< "(0) Save & Exit\n";

		int input;
		if (!(std::cin >> input)) {
			std::cin.clear();
			std::cin.ignore(1000, '\n');
			continue;
		}

		switch (input) {
			case 1 : {
				Patient p;
				std::string name, cond, stat;
				int age;
				std::cin.ignore();
				std::cout << "Name: ";      getline(std::cin, name);
				std::cout << "Age: ";       std::cin >> age; std::cin.ignore();
				std::cout << "Condition: "; getline(std::cin, cond);
				std::cout << "Status: ";    getline(std::cin, stat);
				p.setName(name);
				p.setAge(age);
				p.setCondition(cond);
				p.setStatus(stat);
				console.addPatient(p);
				break;
			}
			case 2 :
				console.listPatients();
				break;
			case 3 : {
				std::string name;
				std::string newStatus;
				std::cout << "Enter patient name: "; 
				std::cin >> name;
				Patient* p = console.searchByName(name);
				if (p) {
					std::cout << "New status: ";
					std::cin >> newStatus;
					p->setStatus(newStatus);
				}
				break;
			}
			case 4 : {
				int id;
				std::cout << "Enter patient ID to delete: ";
				std::cin >> id;
				console.deleteByID(id);
				break;
			}
			case 0 :
				console.saveToFile("patients.json");
				std::cout << "Data saved. Goodbye!\n";
				running = false;
				break;
			default:
				std::cout << "Invalid choice.\n";
		}
	}

	return 0;
}