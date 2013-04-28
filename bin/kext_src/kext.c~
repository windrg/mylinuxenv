#include <stdio.h>
#define SIZE_OF_FILEPATH 256

#define max(a,b) (a>=b ? a : b)
#define DEBUG	

// Someday these below commands will be & should be melted into this sources....but now...^^
// find ./ -name '*.cmd' | xargs grep -h '\.[chS])* *\\$' | sed 's/)//' | sed 's/\\//' | sed 's/$(wildcard//' | sed 's/  *//' > f.txt
// find ./ -name '*.lds' | grep x86

typedef struct 
{
	char	file_path[SIZE_OF_FILEPATH];
       	void * 	next;
}
file_path_element_type;


typedef struct
{
	file_path_element_type * head; 
	int cnt;
} file_list_type;

file_list_type flist = { NULL, 0};



file_list_type * add_file_list(const char * path, size_t len)
{
	file_path_element_type * fpet = (file_path_element_type *) malloc(sizeof(file_path_element_type));
	if ( NULL == fpet )
	{
		fprintf(stderr, "Couldn't allocate memory!!!");
		return NULL;
	}

	bzero((void*)fpet, sizeof(file_path_element_type));
 	strncpy((char *) fpet->file_path, path, len);
	if ( flist.head != NULL && flist.cnt !=0 )
	{
		file_path_element_type * ptrace = flist.head;

		for(;ptrace->next != NULL;ptrace = ptrace->next) // find the last one
			;

		ptrace->next = fpet;
		flist.cnt++;
		return &flist;
	}
	else if ( flist.head == NULL && flist.cnt ==0 )
	{
		fpet->next 	= NULL;

		flist.head 	= fpet;
		flist.cnt 	= 1;
		return 	&flist;
	}	
	else
	{
		fprintf(stderr, "Something is wrong : #%d", flist.cnt);
		free((void*)fpet);
		return NULL;
	}
}

int dump_file_list(void)
{
	int cnt = 0;
	file_path_element_type * pout = flist.head;
	char	absolute_path[SIZE_OF_FILEPATH*2];

	for( ; pout != 0 ; pout = pout->next )
	{
		// now i couldn't find this header files so just ignore it
		if (0 == strncmp("./include/config", pout->file_path, strlen("./include/config") ) )
			       continue;	



		bzero(absolute_path, SIZE_OF_FILEPATH*2);
		if ( !realpath(pout->file_path, absolute_path) )
			fprintf(stdout, "%s", absolute_path); 
		/*
		if ( pout->file_path[0] == '/' )
			fprintf(stdout, "%s", pout->file_path);
		else
			fprintf(stdout, "./%s", pout->file_path);	
		*/
		cnt++;
	}

	return cnt;
}


int destroy_file_list(void)
{
	int ndestroyed = 0;
	file_path_element_type * pfree = NULL;

	if ( 0 == flist.cnt )
		return 0;

	for(;flist.cnt != 0; flist.cnt--,ndestroyed++)
	{
		pfree = flist.head;
		flist.head = pfree->next;
		free((void*) pfree);
	}

	return ndestroyed;
}

static void refine_path(const char * instr, size_t len, char * refinedpath, size_t buflen) // actually it makes the file path start with './'
{
	int i;

	if ( instr[0] == '/' )
	{
		strncpy(refinedpath, instr, len);
		buflen = len;
#ifdef DEBUG	
	fprintf(stdout, "Original : %s", instr);
	fprintf(stdout, "Refined  : %s", refinedpath);
#endif // DEBUG	
		return;
	}

	for( i = 0; i < len; i++)
		if ( isalpha(instr[i]) )
			break;
	
	strncpy(refinedpath, "./",2);
	strncpy(refinedpath+2, instr+i, len-i);
#ifdef DEBUG	
	fprintf(stdout, "Original : %s", instr);
	fprintf(stdout, "Refined  : %s", refinedpath);
#endif // DEBUG	
}

file_path_element_type * is_already_in_the_list(const char * str, size_t len)
{
	file_path_element_type * pcur = flist.head;

	for( ; pcur != NULL ; pcur = pcur->next)
		if (  0 == strncmp((char *)pcur->file_path, str, max(strlen(pcur->file_path),len))  )
		{
			return pcur;
		}
				
	return NULL;
}




int main(int argc,char * argv[])
{
	char cur_filepath[SIZE_OF_FILEPATH] = { 0 };
	char refined_filepath[SIZE_OF_FILEPATH] = { 0 };
	FILE * fp = NULL;

	if ( argc !=2 )
		return -1;

	if ( NULL == (fp=fopen(argv[1], "r")) )
	{
		fprintf(stderr, "error : couldn't open %s", argv[1]);
		return -1;
	}
	

	while( fgets(cur_filepath, SIZE_OF_FILEPATH, fp) != NULL )
	{
		int len = strlen(cur_filepath); 
		refine_path(cur_filepath, len, refined_filepath, SIZE_OF_FILEPATH); 
		len = strlen(refined_filepath); 
		if ( NULL == is_already_in_the_list(refined_filepath, len) )
		{
			file_list_type * pStatus = add_file_list(refined_filepath, len);
			if ( NULL == pStatus )
			{
				fclose(fp);
				destroy_file_list();
				exit(-1);
			}
			else
			{
#ifdef DEBUG
				fprintf(stdout, "Added %08d : %s", pStatus->cnt, refined_filepath);
#endif // DEBUG	
			}

		}
		bzero(refined_filepath, SIZE_OF_FILEPATH);
		bzero(cur_filepath, SIZE_OF_FILEPATH);

	}

	//fprintf(stdout, "\r\n");
	dump_file_list();
	destroy_file_list();

	fclose(fp);

	return 0;
}


