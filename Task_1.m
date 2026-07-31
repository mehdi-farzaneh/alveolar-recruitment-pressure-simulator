function C_hat = Task_1 (C_FRC, K, C_L, SP, TOP, N, P_alv)
H = zeros(1,N);
C_hat = zeros(1,length(P_alv));
if N > length(SP)
    N = length(SP);
end
for i = 1:length(P_alv)
    for j = 1:N
     if P_alv(i) >= (SP(j)+TOP)
         H(j) = 1;
     end
      C_hat(i) = C_hat(i) + C_L*H(j)*exp(-K*(P_alv(i)-SP(j)-TOP));
    end
 C_hat(i) = C_hat(i) + C_FRC*exp(-K*P_alv(i));
end
end
