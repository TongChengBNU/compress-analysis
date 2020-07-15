/************************************************************************
 > File Name: cmpBinary.c
 > Author: Tong Cheng
 > Mail: tong.cheng.8819@outlook.com 
 > Created Time: Sun May 17 18:28:03 2020
************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

int main(int argc, char* argv[]){
	if(argc < 3){
		printf("Correct usage: cmpBinary <dat-1> <dat-2>\n");
		exit(1);
	}
	
	FILE *fd1, *fd2;
	if( (fd1=fopen(argv[1], "rb")) == NULL ){
		printf("Open file %s failed; Error: %d - %s", argv[1], errno, strerror(errno));
		exit(1);
	}
	if( (fd2=fopen(argv[2], "rb")) == NULL ){
		printf("Open file %s failed; Error: %d - %s", argv[2], errno, strerror(errno));
		exit(1);
	}
	int a, b;

	while( (!feof(fd1)) || (!feof(fd2)) ){
		a = fgetc(fd1);
		b = fgetc(fd2);
		if(a != b){
			printf("Position: file %s - %ld || file %s - %ld\n", argv[1], ftell(fd1), argv[2], ftell(fd2));
			printf("Data: %d|| %d\n", a, b);
			printf("Comparison: (%s, %s) - different.\n", argv[1], argv[2]);
			fclose(fd1);
			fclose(fd2);
			exit(0);
		}
	}

	printf("Comparison: (%s, %s) - identical.\n", argv[1], argv[2]);
	fclose(fd1);
	fclose(fd2);
	return 0;
}
