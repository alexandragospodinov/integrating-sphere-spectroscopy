function [iad] = IAD_stream_final(mes, g_vals, lambdas, noMC, beam_d, fname) 
% function [iad] = IAD_stream_final(mes, g_vals, lambdas, noMC) 
% The objective of this function is to run IAD for IS measurements that
% have been put into a "mes" strucutre.
% 
% INPUTS:
% mes - IS measurement vectors 
% g_vals - initial anisotropy guess
% lambdas - wavelength vector
% noMc - flag for MC (1 - noMC) 

% Other inputs to IAD 
nsample = 1.33; nglass = 1.55; 
sample_t = 2; glass_t = 2; 

% beam_d = 3; 
port_d = 25.4; % in mm

% Print message before start 
if noMC == 1 
    fprintf('You are about to run IAD under the following conditions!\n\n'); 
    fprintf('\t - in-built MC has been turned off!\n'); 
    fprintf('\t - sample index = %0.2f \t         glass index = %0.2f\n', nsample, nglass); 
    fprintf('\t - sample thickness = %0.2f mm \t glass thickness = %0.2f mm\n\n', sample_t, glass_t); 
else 
    fprintf('You are about to run IAD under the following conditions!\n\n'); 
    fprintf('\t - in-built MC has been turned on!\n'); 
    fprintf('\t - sample index = %0.2f \t         glass index = %0.2f\n', nsample, nglass); 
    fprintf('\t - sample thickness = %0.2f mm \t glass thickness = %0.2f mm\n', sample_t, glass_t); 
    fprintf('\t - beam diameter = %0.2f mm \t     port diameter = %0.2f mm\n\n', beam_d, port_d); 
end 
fprintf('======== Would you like to continue with IAD? ========\n\n'); %pause; 

% Making IAD dump 
if ~exist('IAD_dump', 'file')
    mkdir IAD_dump; 
end 
cd IAD_dump; 

for c = 1:length(mes) 
    
    iad(c).sol = sprintf(fname, c); 
    
    for fc = 1:length(mes(c).Rt.legends)
        
        iad_file = sprintf('%s_r%d.rxt', iad(c).sol, fc);
        fprintf('Begining IAD analysis of %s!\n', iad_file);
        
        Rt = [mes(c).Rt.lambdas mes(c).Rt.spectra(:,fc)]; 
        Tt = [mes(c).Tt.lambdas abs(mes(c).Tt.spectra(:,fc))]; 
        
        if noMC == 1
            iad(c).s(fc) = IAD_analysis_NoMC(iad_file, nsample, sample_t, ...
            glass_t, nglass, Rt, Tt, g_vals(c), lambdas); 
        else 
            iad(c).s(fc) = IAD_analysis_v2(iad_file, nsample, sample_t, beam_d, port_d, ...
            glass_t, nglass, Rt, Tt, g_vals(c), lambdas); 
        end 
        
    end 
end 

cd ..;
