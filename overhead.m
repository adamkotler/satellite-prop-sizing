%Adam Kotler
close all;
%%
%CONSTANTS
g0=9.81;    %m/s^2
%%
%INPUTS
T=(1:5:75).*1E-3; %milliNewtons
Isp=(20:5:60);    %s
tb=(1800:1800:3600*10); %total burn-time; last value is 1 hour times 10=10 hours
dv=(100:250:9000);      %delta-v required; min is some orbital injection max is satellite orbit around earth no return

%%
%Overhead input
INPUT_O=[];
for z=1:length(T)
    for y=1:length(Isp)
        for x=1:length(tb)
            for w=1:length(dv)
                INPUT_O(end+1,:)=[T(z) Isp(y) tb(x) dv(w)];
            end
        end
    end
end

%%
%Overhead output
OUTPUT_O=[];
for z=1:length(INPUT_O)
    mdot(z)=INPUT_O(z,1)/(g0*INPUT_O(z,2));
    c(z)=g0*INPUT_O(z,2);
    MR(z)=exp(INPUT_O(z,4)/c(z));
    mp(z)=mdot(z)*INPUT_O(z,3);
    m0(z)=(MR(z)*mp(z))/(MR(z)-1);
    mf(z)=m0(z)/MR(z);
    OUTPUT_O(z,:)=[mdot(z) c(z) MR(z) mp(z) m0(z) mf(z)];
end

dat={"Thrust[N]","Isp[s]","Burn-time[s]","Delta-V[m/s]","mdot[kg/s]","ve[m/s]","MR[-]","mp[kg]","m0[kg]","mf[kg]"};
io=horzcat(INPUT_O,OUTPUT_O);
io=num2cell(io);
dat=vertcat(dat,io);
% writecell(dat,"OVERHEAD.csv");
% save OVERHEAD.xls dat
