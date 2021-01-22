
#include <stdio.h>
#include <stdlib.h>

/*
Program to implement a scientific calculator
 ***************************************************************
* Author	 Dept.		 Date 		Notes
 ***************************************************************
* Kaicheng W	 ECSE.	      NOV 5 2020     Initial version .
* Kaicheng W	 ECSE.	      NOV 5 2020     Added error handling .
*/


int main(int argc, char *argv[]) {

	if (argc != 4){
		printf ("Error: invalid number of arguments!");
		printf ("\nscalc <operand1> <operator> <operand2>\n");
		exit (1);
	}

	else if (*argv[2] != '+'){
		printf ("Error: operator can only be + !");
		exit (1);

	}

	int strlen1=0;
	int strlen2=0;

	char *num1 = argv[1];
	char p = 0;

	while (num1[p] != '\0') {
		char tolerance = num1[p]-48;
		if ((tolerance<0) || (tolerance>9)){
			printf ("\nError!! operand can only be positive integers!\n");
                	exit (1);
		}
		strlen1++;
		p++;
	}

	char *num2 = argv[3];
	char j = 0;

	while (num2[j] != '\0') {
                char tolerance = num2[j]-48;
                if ((tolerance<0) || (tolerance>9)){
                        printf ("\nError!! operand can only be positive integers!\n");
                        exit (1);
                }
		strlen2++;
		j++;
	}

//////

//////
	int addcounter=0;
	int msize=0;
	int lesser=0;

	if(strlen1>strlen2) {
		addcounter = strlen1;
		msize = strlen1 + 1;
		lesser = strlen2;
	}
	else {
		addcounter = strlen2;
		msize = strlen2 + 1;
		lesser = strlen1;
	}

	char carry=0;
	int save=msize;
	char out[msize];

	while (lesser != 0) {

		char temp = num1[strlen1-1]-48 + num2[strlen2-1]-48 + carry;
		carry = 0;


                if (temp>=10) {
                        carry = 1;
                        temp -= 10;
                }


		out[msize-1] = temp;

		addcounter--;
		strlen1--;
		strlen2--;
		msize--;
		lesser--;
	}

	if (strlen1>strlen2) {
		while(strlen1!=0){
			char temp = num1[strlen1-1]-48 + carry;
			carry = 0;

                        if (temp>=10) {
                                carry = 1;
                                temp -= 10;
                        }

			out[msize-1] = temp;
			msize--;
			strlen1--;
		}
	}


	else {
		while(strlen2!=0){
			char temp = num2[strlen2-1]-48 + carry;
			carry = 0;

                        if (temp>=10) {
                                 carry = 1;
                                 temp -= 10;
			}

                       out[msize-1] = temp;
                        msize--;
                        strlen2--;


                }
        }

	if(carry==1){
		out[msize-1] = 1;
	}

printf("\n");
	if(carry==1)
	printf("%d", 1);
	for(int i=1; i<save; i++){
		printf("%d", out[i]);
	}

printf("\n");
exit(0);

}
