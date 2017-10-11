#include <stdio.h>
#include <string.h>

void disk2t64(char *, char *);

typedef struct {
	char			header[32];
	unsigned short	version;
	unsigned short	entries;
	unsigned short	used;
	unsigned short	free;
	char			tapedesc[24];
} taperec_t;

typedef struct {
	char			entrytype;
	char			filetype;
	unsigned short	startaddress;
	unsigned short	endaddress;
	unsigned short	free;
	unsigned int	t64offset;
	unsigned int	free2;
	char			filename[16];
} filerec_t;

int main(int argc, char *argv[])
{
	if (3 != argc)
		printf("Usage: %s infile outfile.t64\n", argv[0]);
	else
		disk2t64(argv[1], argv[2]);
	return 0;
}

void error(char *errmsg)
{
	fputs(errmsg, stderr);
	exit(1);
}

void disk2t64(char *inname, char *outname)
{
	char			dataline[256], hexnumb[5] = {0, 0, 0}, byte;
	FILE			*inf, *ouf;
	taperec_t		taperec;
	filerec_t		filerec;
	unsigned int	filecount;
	unsigned long	tapeoffset, checksumline, checksumfile, readnumber, length;
	unsigned short	tmp;
	int				bytevalue;

	memset(&taperec, 0, sizeof(taperec));
	strcpy(taperec.header, "C64S tape image file\0x1a");
	strcpy(taperec.tapedesc, inname);
	for (tmp = 0; tmp < sizeof(taperec.tapedesc); tmp ++) {
		if (taperec.tapedesc[tmp])
			taperec.tapedesc[tmp] = toupper(taperec.tapedesc[tmp]);
		else
			taperec.tapedesc[tmp] = ' ';
	}
	taperec.version = 0x02;	
	
	if (NULL == (inf = fopen(inname, "rt")))
		error("Cannot open input file");
	if (NULL == (ouf = fopen(outname, "wb")))
		error("Cannot create output file");

	puts("Step one: counting files");
	while (NULL != fgets(dataline, sizeof(dataline), inf)) {
		if (strstr(dataline, ":LAENGE") == dataline) {
			taperec.entries ++;
			taperec.used ++;
		}
	}
	printf("%hu files found\n", taperec.entries);
	fwrite(&taperec, sizeof(taperec), 1, ouf);

	rewind(inf);

	tapeoffset = sizeof(taperec) + taperec.entries * sizeof(filerec);

	for (filecount = 0; filecount < taperec.entries; filecount ++) {
		printf("Converting file #%u...\n", filecount);
		puts("* Looking for header...");
		do {
			do {
				fgets(dataline, sizeof(dataline), inf);
			} while (strstr(dataline, ":IMAGE DER ") != dataline);
		} while ('D' == dataline[11]);
		printf("* Found header: %s", dataline);

		memset(&filerec, 0, sizeof(filerec));
		filerec.entrytype = 1;
		switch (dataline[11]) {
		case 'S':
			filerec.filetype = 2;
			break;
		case 'P':
			filerec.filetype = 1;
			break;
		default:
			puts("Filetype ?");
			break;
		}
/*		filerec.filetype = 1; filtyp? */
		filerec.t64offset = tapeoffset;
		strncpy(filerec.filename, &dataline[20], 16);
		for (tmp = 0; tmp < 16; tmp ++) {
			if (filerec.filename[tmp] < 32 || '"' == filerec.filename[tmp])
				filerec.filename[tmp] = ' ';
		}

		puts("* Converting file...");
		fseek(ouf, tapeoffset, SEEK_SET);

		checksumfile = length = 0;
		
		fgets(dataline, sizeof(dataline), inf);
		while ('$' == dataline[0]) {
			checksumline = 0;
			for (tmp = 1; dataline[tmp] != '.' && tmp < 73; tmp += 2) {
				hexnumb[0] = dataline[tmp];
				hexnumb[1] = dataline[tmp + 1];
				sscanf(hexnumb, "%xd", &bytevalue);
				byte = bytevalue;
				if (length > 1) {
					fwrite(&byte, sizeof(byte), 1, ouf);
				}
				else {
					((char *) &filerec.startaddress)[length] = byte;
				}
				checksumline += bytevalue;
				checksumfile += bytevalue;
				length ++;
			}

			sscanf(&dataline[74], "%lu", &readnumber);
			if (readnumber != checksumline)
				error("Line checksum error");

			fgets(dataline, sizeof(dataline), inf);
		}

		/* :CHKSUM */

		sscanf(&dataline[8], "%lu", &readnumber);
		if (readnumber != checksumfile)
			error("File checksum error");

		fgets(dataline, sizeof(dataline), inf);
		/* :LAENGE */

		sscanf(&dataline[8], "%lu", &readnumber);
		if (readnumber != length)
			error("File length error");

		filerec.endaddress = filerec.startaddress + length - 2;
		printf("* File is from %04x to %04x\n", filerec.startaddress,
		       filerec.endaddress);
		tapeoffset += length;

		fseek(ouf, sizeof(taperec) + filecount * sizeof(filerec), SEEK_SET);
		fwrite(&filerec, sizeof(filerec), 1, ouf);
		
/* startaddress, endaddress, filename */
	}

	fclose(inf);
	fclose(ouf);
}