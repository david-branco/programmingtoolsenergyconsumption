### Impact of compilation by Integrated Development Environments in energy consumption during program execution 
Authors: <br>
David Branco (davidbranco88 at gmail.com) <br>
Pedro Rangel Henriques (pedrorangelhenriques at gmail.com) <br>

Project Website: http://www4.di.uminho.pt/~gepl/OCGREC/ <br>
Master's Degree Dissertation: http://www4.di.uminho.pt/~gepl/OCGREC/repository/MSc_Thesis_DBranco_PRHenriques.pdf <br>

Project Structure:
- *rapl-read.c*: measurement software;
- *read.sh*: bash script to automate the measurement process;
- *sources.sh*: lists with elements to be analyzed;
- *Output Processing*: first phase of the data processing obtained from the performed measurements:<br>
-- *Charts*: graphics and generated HTML pages.<br>
-- *Rankings*: classifications and LaTeX tables created.<br>
-- *outputprocessing.pl*: perl script to process the output;<br>
-- *outputmanagement.sh*: bash script to invoke the different types of data processing;<br>
-- *processing.sh*: bash script that manages the input and output processing folders;
- *Outputs*: files resulting from measurements;
- *Results*: results obtained presented in charts, tables, HTML pages and rankings.
- *Source_Files*: source code of measured software (without original input files -- because GitHub size limit restriction);
