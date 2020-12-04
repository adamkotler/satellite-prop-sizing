%%
%Acquire target deltav
fprintf('Select target delta-v: ');
for z=1:length(dv2{1})
    fprintf('%i ',dv2{1}(z));
end
fprintf('\n')
dv_tar=input('');

%%
%Acquire propulsion systems
sys_tab=table;
for a=1:length(T0_t)
    sys_tab(a,:)=tab(f2_idx{a}(find(dv2{1}==dv_tar)),:);
end
T0_0=cell2mat(T0_t);
T0_cell=strcat({'   '}, num2str(T0_0(:)));
sys_tab.Properties.RowNames=T0_cell;

%%
%Convert table to cell to mat to perform math; compare savings/gains 
%acquired due to increased temperature
sys_mat=cell2mat(table2cell(sys_tab));
mf_gain=(sys_mat(:,26)-sys_mat(1,26))./(sys_mat(1,26)).*100;
m0_gain=(sys_mat(1,25)-sys_mat(:,25))./(sys_mat(1,25)).*100;
mp_gain=(sys_mat(1,24)-sys_mat(:,24))./(sys_mat(1,24)).*100;
Isp_gain=(sys_mat(:,21)-sys_mat(1,21))./(sys_mat(1,21)).*100;
%Add new data back to original table
sys_tab.Isp_gain=Isp_gain;
sys_tab.mp_gain=mp_gain;
sys_tab.m0_gain=m0_gain;
sys_tab.mf_gain=mf_gain;

%%
%Print comparisons to baseline

sys_tab_c=table2cell(sys_tab);
sys_tab_t=cell2table(sys_tab_c','RowNames',sys_tab.Properties.VariableNames,'VariableNames',sys_tab.Properties.RowNames);

% fprintf('Select target temperature: ');
% for z=2:length(T0)
%     fprintf('%i ',T0(z));
% end
% fprintf('\n')
% T0_tar=input('');
% T0_tar_idx=find(T0==T0_tar);
% sys_comp(1,:)=sys_tab

%%
%Prompt to write table
str=input("Store table to .csv?[Y/N]\n",'s');
if(strcmp(str,'Y') || strcmp(str,'y') || isempty(str))
    fprintf("Saving data to csv...\n");
    writetable(sys_tab_t,'tabdat.csv','WriteVariableNames',true,'WriteRowNames',true)
end