%%
%Propulsion Inputs
function[INPUTS]=prop_input()
%%
%CONVERSION 
psi_pa=6895;  %psi->Pa
in_m=.0254;   %in->m
lbf_N=4.448;  %lbf->N
%%
%CONSTANTS
g0=9.81;    %[m/s^2]
%%
%INPUT PARAMETERS
Pe=(14.7).*psi_pa;               %exit pressure; Pa
Pc=(200:200:800).*psi_pa;   %Chamber Pressure
F=(1:1:10).*lbf_N;                 %Thrust[N]
T1=1914.82;       %T1 temperature[degK];
k=1.27:.01:1.31;               %Gamma values; Nitrous
Rs=180;                     %NITROUS OXIDE, ENGINEERING TOOLBOX; J/kgK
nCf=.93:.01:.98;                    %Typical nCf
ncstar=.93:.01:.98;                    %Typical nCf
tb=(60*1:60*1:60*7); %total burn-time; [s/m]*minutes
cstar=1108.7; 

%%
%Define string header
str={'Pe[Pa]','Pc[Pa]','F[N]','T1[K]','k','Rs[J/kgK]','nCf','BurnTime[s]','cstar','ncstar'};
%%
%Refined Input
INPUTS={};
INPUTS(1,:)=str;
for b=1:length(Pe)
for z=1:length(Pc)
    for a=1:length(F)
            for x=1:length(T1)
                for w=length(k)
                    for v=length(Rs)
                        for u=length(nCf)
                                for s=length(tb)
                                          for p=1:length(ncstar)
                                                INPUTS(end+1,:)={Pe(b) Pc(z) F(a) T1(x) k(w) Rs(v) nCf(u) tb(s) cstar ncstar(p)};
                                                disp(strcat("INITIALIZING INPUT:",num2str(z)));
                                     
                                      end
                                  
                             end
                         end
                    end
                end
            end
    end
end
end

