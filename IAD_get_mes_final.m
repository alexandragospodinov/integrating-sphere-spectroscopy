function [mes] = IAD_get_mes_final(foldername, lambdas)
% function [mes] = IAD_get_mes_final(foldername, lambdas)
% The objective of this function is to build the "mes" structre that
% comprises all the IS phantom measurements. This code is optimized for a
% linux machine and uses the function "batch_load_spx_data"
% 
% INPUTS: 
% folder_name - Name of the folder containing files and folders in the
%               following format: 
%       Folders - named "sol1", "sol2" ... "soln" 
%                 containing "ref-n.txt" & "trans-n.txt" files 
%       Files - only files named "std-n.txt" & "dark-n.txt" 
% lambdas - wavelength values for computation interest 
% 
% OUTPUTS: 
% mes - structure contatining Rt and Tt data 

cd(foldername); 

% Lets get the Standard and Dark measurements
stdn = batch_load_spx_data('ls std*.SSM | sort', [450:800]);
dark = batch_load_spx_data('ls dark*.SSM | sort', [450:800]);

% To loop through each folder within "folder_name" 
folder_list = locate_files('find . -type d -name "sol*" | sort -V'); 

for fc = 1:length(folder_list)

    cd(char(folder_list(fc))); 
    
    % A label for each scan 
    folder_label = extractAfter(string(folder_list(fc)), './'); 
    mes(fc).sol = folder_label; 
    
    % Lets find all the ref & trans vals & ensure that we only count the
    % least number of files 
    ref = batch_load_spx_data('ls ref*.SSM | sort', [450:800]);
    trans = batch_load_spx_data('ls trans*SSM | sort', [450:800]); 
    
    [mes(fc).Rt, mes(fc).Tt] = get_Rt_Tt_final(ref, trans, dark, stdn, 1, lambdas);  
    
    if any(mes(1).Rt.spectra > 1, 'all')
        warning('Rt values > 1 for sample %d!', fc); 
    elseif any(mes(1).Tt.spectra > 1, 'all')
        warning('Tt values > 1 for sample %d!', fc); 
    end 

    cd ..; 
end 
    
    
