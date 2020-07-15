#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//#define FRAMESIZE 70

int main(int argc, char* argv[]){
	if(argc < 3){
		fprintf(stderr, "Correct usage: test <data> <frame-size>");
		exit(1);
	}
	int FRAMESIZE = atoi(argv[2]);

	char name[30];
	unsigned int count;
	count = 1;
	FILE *rd, *wrt;
	if( (rd=fopen(argv[1], "rb")) == NULL ){
		printf("Cannot open read file %s.\n", argv[1]);
		exit(1);
	}
	char buffer[FRAMESIZE];
	do{
		sprintf(name, "sequence/%d", count);
		if( (wrt=fopen(name, "wb")) == NULL ){
			printf("Cannot write file %s.\n", name);
			exit(1);
		}
		fread(buffer, sizeof(char), FRAMESIZE, rd);
		fwrite(buffer, sizeof(char), FRAMESIZE, wrt);
		printf("Write %d-th file success;\n", count++);
		printf("Current position: %ld\n", ftell(rd));
		memset(buffer, 0x00, FRAMESIZE);
		fclose(wrt);
	}while(!feof(rd));
	//}while(count < 2);



	fclose(rd);
	return 0;
}
