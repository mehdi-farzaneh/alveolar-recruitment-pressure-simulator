classdef Parameters
    % Parameter container and helper routines for the alveolar recruitment model.

    methods (Static)
        function p = defaults()
            % Default physiological parameters for the alveolar recruitment model.
            p.TOP = 0.1;
            p.K = 0.01;
            p.N = 0;
            p.Cfrc = 1;
            p.CL = 0.1;
            p.R = 0.01;
            p.Q = 10;
            p.tinsp = 0.01;
            p.SP = 0:0.5:14.5;
        end

        function p = fromStruct(data)
            p = LungRecruitment.Parameters.defaults();
            if isempty(data)
                return;
            end

            if isfield(data, 'TOP'); p.TOP = data.TOP; end
            if isfield(data, 'K'); p.K = data.K; end
            if isfield(data, 'N'); p.N = data.N; end
            if isfield(data, 'Cfrc'); p.Cfrc = data.Cfrc; end
            if isfield(data, 'CL'); p.CL = data.CL; end
            if isfield(data, 'R'); p.R = data.R; end
            if isfield(data, 'Q'); p.Q = data.Q; end
            if isfield(data, 'tinsp'); p.tinsp = data.tinsp; end
            if isfield(data, 'SP') && ~isempty(data.SP)
                p.SP = data.SP;
            end
        end

        function p = fromApp(app)
            p.TOP = app.input_top.Value;
            p.K = app.input_k.Value;
            p.N = app.input_n.Value;
            p.SP = app.input_sp_start.Value:app.input_sp_steps.Value:app.input_sp_end.Value;
            p.Cfrc = app.input_cfrc.Value;
            p.CL = app.input_cl.Value;
            p.R = app.input_r.Value;
            p.Q = app.input_q.Value;
            p.tinsp = app.input_tinsp.Value;
        end

        function p = loadFromFile(filePath)
            loaded = load(filePath);
            if ~isfield(loaded, 'parameters')
                error('The selected file does not contain a variable called parameters.');
            end
            p = LungRecruitment.Parameters.fromStruct(loaded.parameters);
        end

        function saveToFile(p, filePath)
            parameters = p;
            save(filePath, 'parameters');
        end

        function SP = buildSP(startValue, stepValue, endValue)
            SP = startValue:stepValue:endValue;
        end

        function maxN = validNValue(SP)
            if isempty(SP)
                maxN = 0;
                return;
            end
            maxN = numel(SP);
        end
    end
end
