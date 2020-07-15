/************************************************************************
 > File Name: timer.c
 > Author: Tong Cheng
 > Mail: tong.cheng.8819@outlook.com 
 > Created Time: Tue 19 May 2020 08:48:51 AM CST
************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char* argv[]){

	if(argc != 3){
		fprintf(stderr, "Usage: %s <cmd> <repeat>\n", argv[0]);
		exit(1);
	}

	//clock_t start, end;
	int start, end;
	printf("cmd: %s\n", argv[1]);
	printf("repeat: %s\n", argv[2]);

	int count = atoi(argv[2]);
	if(count == -1){
		fprintf(stderr, "<repeat> parse error.\n");
		exit(1);
	}
	/*
	start = clock();
	for(int i=0; i<count; i++){
		system(argv[1]);
	}
	end = clock();
	double seconds;
	seconds = (end - start)/CLOCKS_PER_SEC;
	printf("Usage time: %.8f\n", seconds);
	*/
	start = time(NULL);
	for(int i=0; i<count; i++){
		system(argv[1]);
	}
	end = time(NULL);
	printf("Usage time: %d\n", end-start);


	return 0;
}
