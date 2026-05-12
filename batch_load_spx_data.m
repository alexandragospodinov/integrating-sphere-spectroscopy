function [data] = batch_load_spx_data(shell_cmd, wavelengths, lambda_min)
%
% find all the files using the shell_cmd
% load spectral data in the range specified by wavelengths

files = locate_files(shell_cmd);
if length(files) < 1
	error('cannot match any files');
end

if ~exist('wavelengths', 'var')
	wavelengths = [400:850]';
elseif isempty(wavelengths)
	wavelengths = [400:850]';
end

if ~exist('lambda_min', 'var')
	lambda_min = [];
end

for f1=1:length(files)
	try 
% 		tmp = read_labview_ccd_data(files{f1}, 1, 1, ' ', lambda_min);
        tmp = load_spectraWiz_data(files{f1});
	catch
		lerr = lasterror;
    for e1=1:length(lerr.stack)
    	disp(sprintf('in %s, %d', lerr.stack(e1).file, lerr.stack(e1).line));
    end
		error('Cannot process file: %s', files{f1});
		return
	end

	spxtra(:,f1) = csaps(tmp(:,1), tmp(:,2), 0.01, wavelengths);
	lt{f1} = sprintf('%d: %s', f1, files{f1});
end

data.spectra = spxtra;
data.lambdas = wavelengths;
data.legends = lt;
