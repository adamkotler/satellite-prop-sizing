t = linspace(0,4*pi,64);
x = .15*square(.999*t)+0.15;

%%
%Plot data
figure(50)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
plot(t/(pi*100),x,'.-')
xlabel('t / \pi')
grid on
grid minor
axis([0 t(end)/(pi*100) 0 max(x)*2])