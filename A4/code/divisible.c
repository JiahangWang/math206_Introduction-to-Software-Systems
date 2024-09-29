#include<stdio.h>


int main() {

	int a,b,c;
	//printf("Please input three numbers:");
	scanf("%d %d %d",&a,&b,&c);

	if (c > b && b > a) {
		if (c % a == 0 && b % a == 0) {
			printf("Divisible & Increasing\n");
			return 0;
		}
		else{
			printf("Not divisible & Increasing\n");
			return 1;
		}
	}
	else{
		if (c % a == 0 && b % a == 0) {
			printf("Divisible & Not increasing\n");
			return 2;
		}
		else {
			printf("Not divisible & Not increasing\n");
			return 3;
		}
	}


}
