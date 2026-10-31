classdef Simulation
    % Model solver for alveolar recruitment and airway pressure.

    methods (Static)
        function [t, my_palv, my_paw] = solve(params)
            SP = params.SP;
            if isempty(SP)
                error('SP vector is empty. Check SP start, step, and end values.');
            end

            N = params.N;
            if N > numel(SP)
                N = numel(SP);
            end

            modelFcn = @(t, my_P) params.Q ./ Task_1(params.Cfrc, params.K, params.CL, SP, params.TOP, N, my_P);
            [t, my_palv] = ode45(modelFcn, 0:0.05:params.tinsp, 0);
            my_paw = params.R * params.Q + my_palv;
        end

        function palv = recruitment(C_FRC, K, C_L, SP, TOP, N, P_alv)
            % Equivalent to the original Task_1 implementation.
            H = zeros(1, N);
            palv = zeros(1, length(P_alv));
            if N > length(SP)
                N = length(SP);
            end
            for i = 1:length(P_alv)
                for j = 1:N
                    if P_alv(i) >= (SP(j) + TOP)
                        H(j) = 1;
                    end
                    palv(i) = palv(i) + C_L * H(j) * exp(-K * (P_alv(i) - SP(j) - TOP));
                end
                palv(i) = palv(i) + C_FRC * exp(-K * P_alv(i));
            end
        end
    end
end
