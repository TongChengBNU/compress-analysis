#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* Buffer size discussion
Assume maximum size of data file is no larger than 100M=10^2 * 2^20;
Length of type long is 8 bytes (64bits);
2^63 > 2^7 * 2^20 > 10^2 * 2^20;
In conclusion, type long is enough to store length value of data;
And it is enough to set buffer size 2^27=134217728;
*/
#define BUFFERSIZE 134217728

long sizeMethod(char *path, long size, char *buffer);
long percentageMethod(char *path, double percentage, char *buffer);


int main(int argc, char *argv[]){
	// check input format
	if( argc!=6 || argv == NULL ){
		fprintf(stderr, "Usage: %s <data> [-s <frame-size> |-p <percentage>] -o <output>\n", argv[0]);
		exit(1);
	}

	// parse option
	char option;
	char *buffer=NULL;
	buffer = (char *)malloc(BUFFERSIZE); // allocate a cache for reading

	long length=-1; // len of buffer; init;
	double percentage;
	// argv[0]: cmd itself
	for(int i=2; i<argc; i++){
		if( argv[i][0] == '-' ){
			// parse option
			option = *++argv[i];
			switch(option){
				case 's': // option: size
					length = sizeMethod(argv[1], atoi(argv[3]), buffer);
					break;	
				case 'p': // option: percentage
					length = percentageMethod(argv[1], atof(argv[3]), buffer);
					break;	
				case 'o': // option: output
					//printf("%d\n", length);
					if(length >= 0){
						FILE *wrt;
						wrt = fopen(argv[5], "wb");
						if(wrt == NULL){
							fprintf(stderr, "Write path error;\n");
							return -1;
						}
						fwrite(buffer, sizeof(char), length, wrt);
						printf("Write succeed with length: %ld;\n", length);
						fclose(wrt);
						free(buffer);
					}else{
						fprintf(stderr, "Nothing to output;\n");
						return -1;
					}
					break;
				default:
					fprintf(stderr, "Unsupported option;\n");
					break;
			}
		}
	}

	return 0;
}

long sizeMethod(char *path, long size, char *buffer){
	FILE *rd;
	if( (rd = fopen(path, "rb")) == NULL ){
		fprintf(stderr, "Open %s error\n", path);
		exit(1);
	}

	fseek(rd, 0L, 2); // ptr to tail
	long length = ftell(rd);
	rewind(rd); // back to head

	// pick up a random beginner
	srand( (unsigned)time(NULL) );
	long begin;
	if( length >= size ){
		begin = rand() % (length - size);
	}else{
		fprintf(stderr, "size bigger than length;\n");
		return -1;		
	}
	fseek(rd, begin, 0); // ptr to head with offset $begin

	/* Debug
	fprintf(stderr, "Path: %s, size: %d\n", path, size);
	fprintf(stderr, "Begin: %ld, length: %ld\n", begin, length);
	*/


	fread(buffer, sizeof(char), size, rd); // buffer has been allocated;
	// don't dump binary into stdout !!!
	// fprintf(stdout, "%s", buffer);
	// sizeof cannot measure dynamic memory

	fclose(rd);
	return size;
}

long percentageMethod(char *path, double percentage, char *buffer){
	FILE *rd;
	if( (rd = fopen(path, "rb")) == NULL ){
		fprintf(stderr, "Open %s error\n", path);
		return -1;
	}

	fseek(rd, 0L, 2); // ptr to tail
	long int length = ftell(rd);
	rewind(rd); // back to head
	fclose(rd);
	
	long size = (long)(length * percentage);
	printf("Estimate size: %ld\n", length);
	return sizeMethod(path, size, buffer);
}
