#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
char ip[50];

/*
Program to implement a scientific calculator
 ***************************************************************
* Author         Dept.           Date           Notes
 ***************************************************************
* Kaicheng W     ECSE.        NOV 15 2020     Initial version .
* Kaicheng W     ECSE.        NOV 15 2020     Added error handling .
* Kaicheng W	 ECSE. 	      NOV 17 2020     Finish + Debug .
*/



typedef struct logrecord{
  char *name;
  char *IPAddress;
} logrecord;

struct logrecord readLog(char logline[]){
  // parse a character array that contains an line from the log
  //    and return a structure that contains the fileds of interest to us.
	char delim[] = ",";
	char *line[7];

	line[0] = strtok(logline, delim);
	for(int i=1; i<7; i++) {
		line[i] = strtok(NULL, delim);
	}

	logrecord myRec;
	myRec.name = line[0];
	myRec.IPAddress = line[6];
	return myRec;
}

bool checkNameExists(FILE* csvfile, char* name, char* ip){
  // Read through the CSV data file, keep looking for the name.
  //  If found, store the IP address associated with the name
  //  to the variable ip and return success.
  // Is bool a valid data type in C? How do you indicate true/false concept in C?
	char line[1024] = "";
	fgets(line, 1024, csvfile);

	while (fgets(line, 1024, csvfile)){
		struct logrecord myRec = readLog(line);
		if (strcmp(myRec.name,name) == 0){
			strcpy(ip, myRec.IPAddress);
			return true;
		}
	}
	return false;
}


bool findCollaborators(char* sname, char *sip, FILE* csvfile, FILE* rptfile){
  // Go through the CSV data file
  //  look for collaborators of sname by looking for entries with the same ip as sip
  //  if any collaborators are found, write it to the output report file.
	char line[1024] = "";
	fgets(line, 1024, csvfile);
	bool flag = false;

	while (fgets(line, 1024, csvfile)){
		struct logrecord myRec = readLog(line);

		if ((strcmp(myRec.IPAddress, sip) == 0) && (strcmp(myRec.name, sname) != 0)) {
			flag = true;
			rptfile = fopen("rpt.txt", "at");
			fprintf (rptfile, "%s",  myRec.name);
			fprintf (rptfile, "\n");
			strcpy (sname, myRec.name);
			fclose (rptfile);
		}

	}
	return flag;

}

int main(int argc, char* argv[]){
  // Do any basic checks, "duct-tape" your full program logic using the above functions,
  //   any house-keeping, etc.
	char line[1024] = "";
	if (argc != 4){
		printf("Usage ./report <csvfile> '<student name>' <reportfile> \n");
		exit(1);
	}

	FILE *file_in;
	file_in = fopen(argv[1], "r");

	if(file_in == NULL){
		printf("Error, unable to open csv file");
		exit(1);
	}

	char* student = argv[2];
	bool flag1;
	flag1 = checkNameExists(file_in, student, ip);

	if (flag1 == false) {
		printf("Error, unable to locate student");
		exit(1);
	}



	file_in = fopen(argv[1], "r");

	FILE *file_out;
	file_out = fopen(argv[3], "w");
	if(file_out == NULL){
                printf("Error, unable to open report file");
                exit(1);
        }

	bool isCollab = findCollaborators(argv[2], ip, file_in, file_out);

	if (isCollab == false) {
		file_out = fopen (argv[3], "w+");
		fprintf (file_out, "No collaborators found for the student");
		fclose (file_out);

	}

	exit(0);
}

