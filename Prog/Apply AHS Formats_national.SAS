/* Apply AHS Formats.SAS */
* Based on Apply AHS 2013 Formats.SAS;
* 02/02/2017 9:41 AM; 
* Program written by Shawn Bucholtz (shawn.j.bucholtz@hud.gov);
* Edits by Dav Vandenbroucke (david.a.vandenbroucke@hud.gov);
/*
     This program inputs the value labels csv file provided by HUD and applies formats
     to the American Housing Survey Public Use Files.
     
     1. It writes the format catalog to a specified SAS library.
     2. It reads the SAS public use files from a specified library and saves them to
          the same library, OVERWRITING the original files and converting them to 
          native encoding.
     
*/

/* User Customization Section ----------------------------------------------------------*/

/* Specify survey year */
%LET Year = 2017;
TITLE Apply AHS &Year. Formats;

/* Specify the list of relational files.  Uncomment the one that is applicable and comment out the one that is not */
%LET RelFileList = household /*Mortgage*/ person project; /* this is for 2015 */
/*%LET RelFileList = newhouse homimp mortg omov owner person ratiov rmov topical;*/ /* this is for 2013 */

/* Specify location of value labels csv file.  INCLUDE the trailing backslash */
%Let InDir = L:\Libraries\RegHsg\Raw\AHS 2017 Value Labels Package\;

%LET CSVFile = AHS &Year. Value Labels.CSV;   /* name of input CSV file*/ 

/* Specify location of AHS Public Use files. Include trailing backslash. Process metro and national files seperately from different file locations*/
LIBNAME AHS "L:\Libraries\RegHsg\Raw\AHS 2017 National PUF v2.0 SAS\" ;

/* location where you want the format catlog to be stored */
LIBNAME Cat  "L:\Libraries\RegHsg\Data\" ;

/* Set the files to be processed.  The choices are:
     RELATIONAL to process the individual SAS files (Newhouse, person, etc.)
     FLATFILE to process a flat file (AHS&Year. or AHS&Year.M).
     BOTH to process the relational files and the flat file (must be in same library).
*/
%LET FileType = BOTH;

/* IF you are adding formats to metropolitan data, change this should be YES.
     For the national data, it should be NO. */
%LET Metro = NO;

/* Double-check that these are the names of the flat files.  We did not always use
     the same conventions. Sometimes the "N" was omitted from the national file. */
%LET NationalFlatName = AHS&Year.N;
%LET MetroFlatName = AHS&Year.M;

/* End of user customization Section --------------------------------------------------*/

/* Macro definition area --------------------------------------------------------------*/
%macro applyFormats (dataset=);
     /* note that this macro uses the global macro variables InDir and METRO.
          It also uses IsFlat, which is set by the calling macrol, Wrapper.
     */

     data &dataset.;     /* Copy the dataset to the WORK library.  This also converts it
                         to native encoding, which is necessary for PROC DATASETS */
          set AHS.&dataset.;
     RUN;     

     filename outfile1 "&InDir.fmtincl2.txt" lrecl=32767;

     %let mydd1=%upcase(&dataset);

     data _null_; 
          file outfile1; 
     run;

     data _null_ ;
          file outfile1 mod;
          set temp3;
          %IF "&IsFlat." = "NO" %THEN %DO; /* relational tables */
               if table="&&mydd1" ;     /* select variables in this table */
               /*
                    Note:  There are some variables that are in the national NEWHOUSE and
                    MORTG tables that are not in the metro.  This section excludes the 
                    national-only variables from the metro processing, thus preventing 
                    some warning messages.
               */
               %IF "&METRO." = "YES" %THEN %DO; /* Select relational table and metro variables */
                    if table IN("HOUSEHOLD","MORTGAGE") AND METRO = 'NO' THEN DELETE; 
               %END; /* of if metro = yes */
          %END; /* of if isflat = no... */
          
          %ELSE %DO; /* one of the flat files */
               %IF "&Metro." = "YES" %THEN %DO;
                    if METRO = 'YES'; /* select variables in the metro flat file */
               %END; /*metro flat selection */
               %ELSE %DO;
                    if FLAT = 'YES'; /* select variables in the national flat file */
               %END; /* national flat selection*/
          %END; /* flat file selection */

          if TYPE='C' then put 'FORMAT ' name  '$' FMTNAME +(-1) '. ; ' ;
          if TYPE='N' then put 'FORMAT ' name  FMTNAME +(-1) '. ; ' ;
     run;

     proc datasets  NOLIST ;
           modify &dataset.;
           %include outfile1; /* inserts format statements created in previous step */

           COPY IN=WORK OUT=AHS; /* copies modified dataset back to AHS library */
               SELECT &dataset.;
          quit;
     run;
%mend; /* applyFormats */

%MACRO Wrapper;
     /* this macro chooses whether to apply the formats to the relational or flat files
          and then runs the applyFormats macro to do that */
     /* Note that this macro uses the global macro variables FileType, Metro,
          MetroFlatName, and NationalFlatName */     
          
     %IF "&FileType." = "RELATIONAL" OR "&FileType." = "BOTH" %THEN %DO;
     /* loop through list of relational tables */
          %LET IsFlat = NO; /*not processing flat file */
          %LET Counter = 1;
          %LET RelFile = %SYSFUNC(SCAN(&RelFileList.,1));
          %DO %UNTIL (&RelFile = );
               %applyFormats(dataset=&RelFile);
               %LET Counter = %EVAL(&Counter. +1);
               %LET RelFile = %SYSFUNC(SCAN(&RelFileList.,&Counter.));
          %END; /* of do until */
     %END;     /* of relational */     

     %IF "&FileType." = "FLATFILE" OR "&FileType." = "BOTH" %THEN %DO;
          /* flat file */
          %LET IsFlat = YES; /*processing flat file */
          %IF "&METRO." = "YES" %THEN 
               %applyFormats(dataset=&MetroFlatName.);
          %ELSE
               %applyFormats(dataset=&NationalFlatName.);
     %END;     /* of flatfile */     
%MEND; /* wrapper */     


/* end of macro definition area --------------------------------------------------------*/

OPTIONS FMTSEARCH=(Cat); /* allow SAS to find the format catalog */

*Step 1:  Import the Formats CSV file into SAS;
PROC IMPORT 
     DATAFILE="&InDir.&CSVFile." 
     OUT=temp   
     DBMS=CSV  
     REPLACE
     ;    /* end of proc statement */
     GUESSINGROWS=32767;
     GETNAMES=YES;
run;

*Step 2:  Reshape the new SAS dataset into the type SAS dataset that Proc Format can
     utilize;
data temp1;
     set temp;
     if value not in ('-6','-7','-8','-9'); *these values are not used in SAS version of the PUFs;
     rename value=START;
     end=value;
     drop table;
run;

/*This code eliminates duplicate formating rows caused by variables that are found on
     multiple AHS tables or share a common format name */
proc sort data=temp1 out=temp2 nodupkey ;
     by FMTNAME START END LABEL TYPE;
run;

*Step 3:  Build the Format Catalog;
proc format LIBRARY=Cat
     cntlin = temp2;
run;


*Step 4:  Use Macro "applyFormats" to apply the SAS formats to a working copy of each AHS dataset (created in your working directory);

*Use the original imported data set to create a temp data set with one row for each AHS variable, by table;
proc sort data=temp out=temp3 nodupkey;
     by table name fmtname type;
run;

*Run the macros;

%wrapper;


