Q = 700;
C_FRC_test = 45;
K_test = 0.03;
C_L_test = 1.7;
SP_test = (0:0.5:14.5);
TOP_test = 10;
N_test = 30;
my_P = 0:0.1:35;

t_span = 0:0.05:2;
initial_p = 0;
[t,my_palv]=ode45(@(t,my_P) Q./Task_1(C_FRC_test,K_test,C_L_test, ...
    SP_test,TOP_test,N_test,my_P),t_span,initial_p);

plot(t, my_palv,'b', 'linewidth', 2)
xlabel('time [s]')
ylabel('alv pressure [mbar]')
