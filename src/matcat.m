function integrity = matcat(matfilename)
% MAT-File Corruption Analysis Tool (MATCAT)
% version 3, June 2005.
%
% This tool is intended to be run within MATLAB 5 (R8) or later
% to determine whether a v5 MAT-File is corrupted.
% Currently only v5 MAT-Files are supported.
%
% Usage example of how to use this function:
% given a v5 MAT-File 'myfile.mat' which you want to know whether it is corrupted:
%
%   matcat myfile.mat
%   good = matcat('myfile.mat')
%
% Return value:
%
%   0 = failure (bad v5 MAT-File)
%   1 = success (good v5 MAT-File)
%
% Special note:
%
%   'v5' refers to version 5 of the MAT-File format,
%   not the version of MATLAB itself.
%
%   The MAT-File format is documented here:
%   http://www.mathworks.com/access/helpdesk/help/pdf_doc/matlab/matfile_format.pdf
%
%   The version 5 MAT-File format has been in use starting in
%   MATLAB version 5.0 (R8), November 1996,
%   through the present MATLAB version 7 (R14sp2) and later.

integrity = 0; % return value - 0 = failure (bad MAT-File), 1 = success (good MAT-File)

fprintf('MAT-File Corruption Analysis Tool (MATCAT) version 2, February 2005\n');

f=fopen(matfilename,'rb'); % open mat file

if f < 3 fprintf('fopen failed (can not open MAT-File: %s)\n',matfilename); return; end

fprintf('file ''%s'' opened successfully\n',char(matfilename));

%------ file opened successfully at this point

a=fread(f,6,'uchar'); % read 'MATLAB' from the file - first 6 bytes of header

if 1 ~= all(a'=='MATLAB') fprintf('bad/unrecognized v5 MAT-File header - does not start with ''MATLAB''\n'); fclose(f); return; end

fseek(f,128,'bof'); a=ftell(f); % skip header - position (should be 128)

if 128 ~= a fprintf('fseek failed (bad v5 MAT-File header)\n'); fclose(f); return; end

%------ file has at least 128 bytes (size of MAT-File header) and appears to be a MAT-File (starts with 'MATLAB')

fseek(f,126,'bof'); % goto position of endian indicator MI [0x4d49] = native, IM [0x494d] = need to swap

a=fread(f,1,'uint16'); % read 16 bit int endian indicator

% determine if numeric data read from this file needs to be endian-swapped or not

if a == 19785 % 0x4d49 = 19785 = 'MI', 0x494d = 18765 = 'IM'

	fprintf('numeric data in this MAT-File does not need to be endian-swapped when read on this computer\n');

else

	if a == 18765 fprintf('numeric data in this MAT-File has to be endian-swapped when read on this computer\n');

		% at this point there are two possibilities:

		% (a) this is a big endian computer and the MAT-File was saved on a little endian computer,
		% or (b) this is a little endian computer and the MAT-File was saved on a big endian computer,
		% we don't know which, so close the file and open it in big endian mode.

		% If the file doesn't need to be swapped anymore then (b) applies.
		% If it still needs to be swapped, then (a) applies, so close the file again and open it
		% in little endian mode.

		fclose(f);

		f=fopen(matfilename,'rb','b'); % open mat file using big endian format for numeric data

		fseek(f,126,'bof'); % goto position of endian indicator MI [0x4d49] = native, IM [0x494d] = need to swap

		a=fread(f,1,'uint16'); % read 16 bit int endian indicator

		if a == 18765 % still need to be swapped, try little endian format for numeric data

			fclose(f);

			f=fopen(matfilename,'rb','l'); % open mat file using little endian format for numeric data
		end
	else

		fprintf('2-byte endian indicator at zero-based offset 126 is neither ''MI'' nor ''IM'' (bad v5 MAT-File header)\n');

		fclose(f); return;

	end

end

%------ file is now opened in the correct endian mode for numeric data

fseek(f,0,'bof'); % go back to beginning of file

a=fread(f,116,'uchar'); fprintf('MAT-File header:\n[%s]\n',char(a)); % read v5 MAT-File header text field (116 bytes total) and print it out

%------ 116 byte header text field printed out

subsysdata=fread(f,8,'uchar'); % read subsystem data offset - none if all ascii 0 (null) or all ascii 32 (space)

if all(subsysdata == [0;0;0;0;0;0;0;0]) | all(subsysdata == [' ';' ';' ';' ';' ';' ';' ';' '])

	fprintf('this MAT-File does not have subsystem data (not all MAT-Files have this)\n');

else

	fseek(f,116,'bof'); % go back to position of 8 byte int subystem data offset

	fprintf('this MAT-File has subsystem data (an extra variable at the end - not all MAT-Files have this) at byte offset: ');

	subsysdata=fread(f,1,'uint64') % read subsystem data offset and print it out directly since it is an uint64 to avoid precision loss

end

%------ subsystem data 8-byte-int offset shown, if any

a=fread(f,1,'uint16'); % read v5 MAT-File version (should be 0x100 = 256)

if 256 ~= a fprintf('WARNING - MAT-File version should be 0x100 - instead it is %d so the following output may not be correct\n',a); end

%------ 2-byte-int MAT-File version check

fseek(f,128,'bof'); % skip MAT-File header

fprintf('128 byte v5 MAT-File header ok\n\n');

varnum = 0;
integrity = 1;
iscompressed = 0;

while 1
	a=fread(f,2,'int32'); % read datatype and bytes to skip

	x=size(a); % rows, cols

	if 0 == x(2) break; end % end of file

	if 2 ~= x(1) | 1 ~= x(2)
		fprintf('\nerror - fread TAG failed\n');
		integrity = 0;
		break;
	end

	varnum = varnum + 1;

	datatype = 'UNKNOWN-OR-ERROR';
	if 1 == a(1) datatype = 'INT8'; end
	if 2 == a(1) datatype = 'UINT8'; end
	if 3 == a(1) datatype = 'INT16'; end
	if 4 == a(1) datatype = 'UINT16'; end
	if 5 == a(1) datatype = 'INT32'; end
	if 6 == a(1) datatype = 'UINT32'; end
	if 7 == a(1) datatype = 'FLOAT'; end
	if 8 == a(1) datatype = 'FLOATVAXS'; end
	if 9 == a(1) datatype = 'DOUBLE'; end
	if 10 == a(1) datatype = 'DOUBLEVAXD'; end
	if 11 == a(1) datatype = 'DOUBLEVAXG'; end
	if 12 == a(1) datatype = 'INT64'; end
	if 13 == a(1) datatype = 'UINT64'; end
	if 14 == a(1) datatype = 'MATRIX'; end
	if 15 == a(1) datatype = 'COMPRESSED'; iscompressed = 1; end
	if 16 == a(1) datatype = 'UTF8'; end
	if 17 == a(1) datatype = 'UTF16'; end
	if 18 == a(1) datatype = 'UTF32'; end

	fprintf('variable %d TAG: datatype_%d (%s), data bytes: %d\n',varnum,a(1),datatype,a(2));

	if a(1) < 1
		fprintf('\nerror - incorrect data type, file appears corrupted\n');
	end

	if a(2) < 1
		fprintf('\nerror - incorrect number of data bytes\n');
		if 15 == a(1) & 0 == a(2)
			fprintf('compressed variable with 0 bytes in tag - this is fixed in R14sp1\n');
			fprintf('To avoid this issue in the future please install R14sp1 or later.\n\n');
			fprintf('If this MAT-File was saved in R14sp1 or R14sp2, then this is a different\n');
			fprintf('bug related to objects that are skipped during save, which is fixed in R14sp3.\n');
			fprintf('This file may be fixable using the MATZEROFIX tool so try it first.\n\n');
			if varnum > 1
				fprintf('Alternatively, you can also try these instructions:\n');
			end
		end
	end

	if a(1) < 1 | a(2) < 1 % messages printed above for these cases
		if varnum > 1
			fprintf('The first %d bytes (%d variables) of this file are good\n',p,varnum-1);
			fprintf('so copy these to a new file and then you can load them in matlab - like so:\n\n');
			fprintf('\tf=fopen(''%s'');fx=fopen(''fixedmatfile.mat'',''w'');\n',matfilename);
			fprintf('\tbytes=fread(f,%d,''uint8'');fwrite(fx,bytes,''uint8'');\n\tfclose(f);fclose(fx);\n\n',p);
			fprintf('\tload fixedmatfile.mat\n\n');
		end
		integrity = 0;
		break;
	end

	b=fread(f,a(2),'uint8'); % skip variable

	x=size(b); % rows, cols
	if a(2) ~= x(1) | 1 ~= x(2)
		fprintf('\nerror - fread %d DATA bytes failed, got %d bytes\n',a(2),x(1));
		if x(1) < a(2) & 1 == x(2) fprintf('SHORT MAT-File, at least %d bytes are missing\n',a(2)-x(1)); end
		integrity = 0;
		break;
	end

	p=ftell(f); % display position

	fprintf('byte: %d\n',p);
end

fclose(f);

if iscompressed
	fprintf('\nThis MAT-File contains compressed variable(s) so it is loadable in R14 or later.\n');
	fprintf('To make this file loadable in previous versions of MATLAB, load it in R14 and then\n');
	fprintf('save it using the save -v6 option or set your\n');
	fprintf('File->Preferences...->General->MAT-Files to ''Ensure backward compatibility (-v6)''\n');
end

if integrity s = 'completed successfully'; else s = 'FAILED'; end

fprintf('\nMAT-File integrity check %s for (%s), %d variable(s) found\n',s,matfilename,varnum);

