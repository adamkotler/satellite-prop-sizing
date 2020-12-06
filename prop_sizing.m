%%
%Acquire Inputs
%INPUTS(end+1,:)={'Pe[Pa]','Pc[Pa]','F[N]','T1[K]','k','Rs[J/kgK]','nCf','BurnTime[s]','AreaRatio','Cf','cstar','nCf','ncstar'}
[INPUTS]=prop_input();

%%
%Acquire Pressure ratio and CF function
[PRAT_0,CF_0]=cfinterp();

%%
%Create string headers
header_1=INPUTS(1,:);
header_2={'Pressure Ratio','CF','mdot[kg/s]','Isp[s]','mp[kg]','vt[m/s]','v2[m/s]','V1[m/s]','V2[m/s]','At[m^2]','A2[m^2]','ARAT[-]'};

%%
%OUTPUT
for z=2:length(INPUTS) %SKIP FIRST INPUT WHICH IS HEADER STRINGS
    %Performance
    tol=.1;
    cf_idx=find(abs(round(PRAT_0,1)-round(INPUTS{z,2}/INPUTS{z,1},1))<=tol,1);
    disp(round(INPUTS{z,2}/INPUTS{z,1},1))
    PRAT(z)=PRAT_0(cf_idx);
    CF(z)=CF_0(cf_idx);
    mdot(z)=INPUTS{z,3}/(CF(z)*INPUTS{z,9}*INPUTS{z,7}*INPUTS{z,10});
    Isp(z)=(INPUTS{z,3})/(mdot(z)*9.81);         %FULL THROTTLE ISP
    mp(z)=mdot(z)*INPUTS{z,8};
    %Nozzle Calculations
    vt(z)=sqrt(INPUTS{z,4}*INPUTS{z,6}*2*INPUTS{z,5}/(INPUTS{z,5}+1));
    v2(z)=sqrt((INPUTS{z,4}*INPUTS{z,6}*2*INPUTS{z,5}/(INPUTS{z,5}-1))*(1-(INPUTS{z,1}/INPUTS{z,2})^((INPUTS{z,5}-1)/(INPUTS{z,5}))));
    V1(z)=INPUTS{z,4}*INPUTS{z,6}/INPUTS{z,2};
    Vt(z)=V1(z)*((INPUTS{z,5}+1)/2)^(1/(INPUTS{z,5}-1));
    V2(z)=V1(z)*(INPUTS{z,2}/INPUTS{z,1})^(1/INPUTS{z,5});
    At(z)=mdot(z)*Vt(z)/vt(z);
    A2(z)=mdot(z)*V2(z)/v2(z);
    ARAT(z)=A2(z)/At(z);
    %Consolidate all data
    temp(z,:)=[PRAT(z) CF(z) mdot(z) Isp(z) mp(z) vt(z) v2(z) V1(z) Vt(z) At(z) A2(z) ARAT(z)];
    disp(strcat("CALCULATING OUTPUT:",num2str(z)));
end
temp(1,:)=[];
%%
%Consolidate data
OUTPUTS=vertcat(header_2,num2cell(temp));
io=horzcat(INPUTS,OUTPUTS);

%%
%SAVE DATA
fprintf("Saving input data...\n");
save INPUTS.mat INPUTS
fprintf("Input data Saved.\n")
fprintf("Saving output data...\n")
save OUTPUTS.mat OUTPUTS
fprintf("Output data Saved.\n")
fprintf("Consolidating data...\n")
save dat.mat io
fprintf("Finished.\n")
tab=cell2table(io(2:end,:),'VariableNames',horzcat(header_1,header_2));
%writecell(dat,"REFINED_DATA.csv");