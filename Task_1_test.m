C_FRC_test = 45;
K_test = 0.03;
C_L_test = 1.7;
SP_test = (0:0.5:14.5);
TOP_test = 10;
N_test = 30;
my_P = 0:0.1:35;

my_C = Task_1(C_FRC_test,K_test,C_L_test,SP_test,TOP_test,N_test,my_P);
my_V = my_C .* my_P;
plot(my_P, my_V,'b', 'linewidth', 2)
xlabel('alv pressure [mbar]')
ylabel('alv volume [ml]')
