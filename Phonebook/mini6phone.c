#include<stdio.h>
#include<string.h>


struct PHONE_RECORD {
	char name[50];
	char birthdate[12];
	char phone[15];
} phonebook[10];

FILE* file;
int recordNum;



void cleanup() {    // clean the buffer zone
	char d;
	while ((d = getchar()) != '\n');
}


void loadRecord(char arr[], int num) { // load a single record into the phone book
	int i, j;
	for (i = 0, j = 0; i < 199 && arr[i] != '\0' && arr[i] != ','; i++, j++) {
		phonebook[num].name[j] = arr[i];
	}
	i++;
	phonebook[num].name[j] = '\0';
	for (j = 0; i < 199 && arr[i] != '\0' && arr[i] != ','; i++, j++) {
		phonebook[num].birthdate[j] = arr[i];
	}
	i++;
	phonebook[num].birthdate[j] = '\0';
	for (j = 0; i < 199 && arr[i] != '\0' && arr[i] != ',' && arr[i] != '\n'; i++, j++) {
		phonebook[num].phone[j] = arr[i];
	}
	phonebook[num].phone[j] = '\0';
}


int loadCSV() {          // return errorcode, otherwise load data structure
	file = fopen("./phonebook.csv", "rt");
	if (file == NULL) {
		recordNum = 0;
		return -1;
	}

	char tmp[200];
	fgets(tmp, 200, file);
	int num = 0;
	char* judge = tmp;
	while (!feof(file) && judge != NULL && *(judge) != '\n') {
		judge = fgets(tmp, 200, file);
		if (judge != NULL  && *(judge) != '\n') {
			loadRecord(tmp, num);
			num++;
		}
	}
	recordNum = num;
	fclose(file);
	return 0;
}

int saveCSV() {              // return errorcode, otherwise save data structure
	if (recordNum == 0) {
		return 0;
	}
	file = fopen("./phonebook.csv", "wt");
	fprintf(file, "Name,birthdate,phone\n");
	for (int i = 0; i < recordNum; i++){
		fprintf(file, "%s,", phonebook[i].name);
		fprintf(file, "%s,", phonebook[i].birthdate);
		fprintf(file, "%s\n", phonebook[i].phone);
	}
	return 0;
}

int addRecord() {             // return errorcode, otherwise add a new phone entry
	if (recordNum >= 10) {
		printf("No more space in the CSV file\n");
		return -1;
	}
	printf("Name: ");
	fgets(phonebook[recordNum].name, 50, stdin);
	char* ch = strstr(phonebook[recordNum].name, "\n");
	if (ch) *ch = '\0';
	else cleanup();

	printf("Birth: ");
	fgets(phonebook[recordNum].birthdate, 12, stdin);
	ch = strstr(phonebook[recordNum].birthdate, "\n");
	if (ch) *ch = '\0';
	else cleanup();

	printf("Phone: ");
	fgets(phonebook[recordNum].phone, 15, stdin);
	ch = strstr(phonebook[recordNum].phone, "\n");
	if (ch) *ch = '\0';
	else cleanup();

	recordNum++;
	return 0;
} 

int findRecord() {              // return errorcode, otherwise return index of found
	printf("Find name: ");
	char target[50];
	fgets(target, 50, stdin);
	char* ch = strstr(target, "\n");
	if (ch) *ch = '\0';
	else cleanup();
	for (int i = 0; i < recordNum; i++){
		if (strcmp(target, phonebook[i].name) == 0) {
			printf("\n----NAME--------- ------BIRTH------ -----PHONE-------\n");
			printf("%-18s", phonebook[i].name);
			printf("%-18s", phonebook[i].birthdate);
			printf("%-18s\n", phonebook[i].phone);
			return 0;
		}
	}
	printf("Does not exist\n");
	return -1;
} 

int listRecords() {                // return errorcode, otherwise displays pretty all
	if (recordNum == 0) {
		printf("No data in the file\n");
		return 0;
	}
	printf("\n----NAME--------- ------BIRTH------ -----PHONE-------\n");
	for (int i = 0; i < recordNum; i++){
		printf("%-18s", phonebook[i].name);
		printf("%-18s", phonebook[i].birthdate);
		printf("%-18s\n", phonebook[i].phone);
	}
	return 0;
} 







