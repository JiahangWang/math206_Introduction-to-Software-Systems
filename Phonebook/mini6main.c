#include<stdio.h>
#include<stdlib.h>
#include<string.h>

void cleanup();
int loadCSV();
int saveCSV();
int addRecord();
int findRecord();
int listRecords();

int fileExist;

int menu() { // to display the prompt and return the input
	char choice = 0;
	char judge[1000];

	printf("Phonebook Menu: (1)Add, (2)Find, (3)List, (4)Quit > ");

	fgets(judge, 100, stdin);
	char* ch = strstr(judge, "\n");
	if (ch) *ch = '\0';
	if (strlen(judge) == 1) {
		choice = judge[0];
	}

	if (choice == 49) {
		addRecord();
		fileExist = 0;
		return 0;
	}
	else if (choice == 50) {
		if (fileExist == -1) {
			printf("Phonebook.csv does not exist\n");
			return 0;
		}
		findRecord();
		return 0;
	}
	else if (choice == 51) {
		if (fileExist == -1) {
			printf("Phonebook.csv does not exist\n");
			return 0;
		}
		listRecords();
		return 0;
	}
	else if (choice == 52) {
		if (fileExist == -1) {
			system("touch phonebook.csv");
		}
		saveCSV();
		printf("End of phonebook program\n");
		return -1;
	}
	else {
		printf("Not valid input\n");
		return 0;
	}
}

int main() { // loops until 4 selected, call mini6phone.c functions

	int over = 0;
	fileExist =	loadCSV(); 
	while (over == 0){
		over = menu();
	}

	return 0;
}
