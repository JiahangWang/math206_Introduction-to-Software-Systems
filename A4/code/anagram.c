#include<stdio.h>
#include<string.h>


int main(int argc, char *argv[]) {

	char *word1;
	char *word2;
	word1 = argv[1];
	word2 = argv[2];

	if (strlen(word1) != strlen(word2)) {
		printf("Not an anagram\n");
		return 1;
	}

	for (int i = 0; i < strlen(word1); i++) {
		int judge = 0;
		for (int j = 0; j < strlen(word2); j++) {
			if (word2[j] == word1[i]) {
				judge = 1;
				word2[j] = '?';
				break;
			}
		}
		if (judge == 0) {
			printf("Not an anagram\n");
			return 1;
		}
	}

	printf("Anagram\n");
	return 0;

}
