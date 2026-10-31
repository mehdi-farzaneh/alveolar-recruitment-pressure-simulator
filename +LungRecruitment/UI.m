classdef UI < handle
    % Graphical user interface for alveolar recruitment modeling.

    properties
        theme
        UIFigure
        sidePanel
        UIAxes
        fields
        CLmLmbarEditFieldLabel
        C_FRCmLmbarEditFieldLabel
        TOPmbarEditFieldLabel
        K1mbarEditFieldLabel
        RmLsmbarEditFieldLabel
        QmLsEditFieldLabel
        NEditFieldLabel
        tinspsEditFieldLabel
        SPEditFieldLabel
        EditField_9Label
        EditField_10Label
        input_cl
        input_cfrc
        input_top
        input_k
        input_r
        input_q
        input_n
        input_tinsp
        input_sp_start
        input_sp_steps
        input_sp_end
        button_load
        button_save
        button_simulate
        data
    end

    methods
        function obj = UI()
            obj.theme = LungRecruitment.Theme.getTheme();
            obj.build();
        end

        function build(obj)
            obj.UIFigure = uifigure('Visible', 'off');
            obj.UIFigure.Position = [100 100 640 480];
            obj.UIFigure.Name = 'Lung Recruitment Simulation';
            obj.UIFigure.Color = obj.theme.figureBg;
            obj.UIFigure.CloseRequestFcn = @(src, evt) delete(src);

            obj.sidePanel = uipanel(obj.UIFigure);
            obj.sidePanel.Title = '';
            obj.sidePanel.BackgroundColor = obj.theme.panelBg;
            obj.sidePanel.BorderType = 'none';
            obj.sidePanel.Position = [12 12 195 455];

            obj.UIAxes = uiaxes(obj.UIFigure);
            obj.UIAxes.Position = [235 84 379 359];
            obj.UIAxes.Color = obj.theme.axesBg;
            obj.UIAxes.XColor = obj.theme.text;
            obj.UIAxes.YColor = obj.theme.text;
            obj.UIAxes.GridColor = obj.theme.grid;
            obj.UIAxes.XGrid = 'on';
            obj.UIAxes.YGrid = 'on';
            title(obj.UIAxes, 'airway pressure');
            xlabel(obj.UIAxes, 'time [s]');
            ylabel(obj.UIAxes, 'pressure [mbar]');
            zlabel(obj.UIAxes, 'Z');

            obj.fields = struct();
            definitions = obj.fieldDefinitions();

            for i = 1:numel(definitions)
                def = definitions{i};
                obj.(def.labelFieldName) = obj.createLabel(obj.UIFigure, def.labelText, def.labelPos, obj.theme.text);
                obj.(def.fieldName) = obj.createNumericField(obj.UIFigure, def.limits, def.defaultValue, def.fieldPos, obj.theme.fieldBg, obj.theme.fieldText, 'off');
                obj.fields.(def.fieldName) = obj.(def.fieldName);
            end

            obj.SPEditFieldLabel = obj.createLabel(obj.UIFigure, 'SP', [26 33 25 22], obj.theme.text);
            obj.input_sp_start = obj.createNumericField(obj.UIFigure, [0 1], 0, [58 30 24 28], obj.theme.fieldBg, obj.theme.fieldText, 'off');
            obj.EditField_9Label = obj.createLabel(obj.UIFigure, ':', [81 34 10 22], obj.theme.text);
            obj.input_sp_steps = obj.createNumericField(obj.UIFigure, [0 5], 0.5, [97 31 43 28], obj.theme.fieldBg, obj.theme.fieldText, 'off');
            obj.EditField_10Label = obj.createLabel(obj.UIFigure, ':', [143 34 10 22], obj.theme.text);
            obj.input_sp_end = obj.createNumericField(obj.UIFigure, [0 99], 14.5, [159 31 42 28], obj.theme.fieldBg, obj.theme.fieldText, 'off');

            obj.fields.SP_start = obj.input_sp_start;
            obj.fields.SP_step = obj.input_sp_steps;
            obj.fields.SP_end = obj.input_sp_end;

            obj.button_load = obj.createButton(obj.UIFigure, 'Load', [223 30 122 25], obj.theme.button, obj.theme.buttonText);
            obj.button_load.ButtonPushedFcn = @(src, evt) obj.buttonLoadPushed();
            obj.button_load.UserData = struct('defaultBg', obj.theme.button, 'hoverBg', obj.theme.buttonHover, 'pressedBg', obj.theme.buttonPressed);

            obj.button_save = obj.createButton(obj.UIFigure, 'Save', [365 30 122 25], obj.theme.button, obj.theme.buttonText, 'off');
            obj.button_save.ButtonPushedFcn = @(src, evt) obj.buttonSavePushed();
            obj.button_save.UserData = struct('defaultBg', obj.theme.button, 'hoverBg', obj.theme.buttonHover, 'pressedBg', obj.theme.buttonPressed);

            obj.button_simulate = obj.createButton(obj.UIFigure, 'Simulate', [504 31 122 25], obj.theme.button, obj.theme.buttonText, 'off');
            obj.button_simulate.ButtonPushedFcn = @(src, evt) obj.buttonSimulatePushed();
            obj.button_simulate.UserData = struct('defaultBg', obj.theme.button, 'hoverBg', obj.theme.buttonHover, 'pressedBg', obj.theme.buttonPressed);

            obj.UIFigure.WindowButtonMotionFcn = @(src, evt) obj.updateButtonHover(src);

            obj.data = struct();
            obj.setFieldEnable('off');

            obj.input_top.Value = 0.1;
            obj.input_k.Value = 0.01;
            obj.input_r.Value = 0.01;
            obj.input_q.Value = 10;
            obj.input_n.Value = 0;
            obj.input_tinsp.Value = 0.01;
            obj.input_sp_start.Value = 0;
            obj.input_sp_steps.Value = 0.5;
            obj.input_sp_end.Value = 14.5;
            obj.input_cfrc.Value = 1;
            obj.input_cl.Value = 0.1;

            obj.input_sp_start.ValueChangedFcn = @(src, evt) obj.updateNLimit();
            obj.input_sp_steps.ValueChangedFcn = @(src, evt) obj.updateNLimit();
            obj.input_sp_end.ValueChangedFcn = @(src, evt) obj.updateNLimit();
            obj.input_n.ValueChangedFcn = @(src, evt) obj.updateNLimit();

            obj.UIFigure.Visible = 'on';
        end

        function defList = fieldDefinitions(obj)
            defList = {
                struct('labelFieldName', 'CLmLmbarEditFieldLabel', 'fieldName', 'input_cl', ...
                    'labelText', 'CL [mL/mbar]', 'labelPos', [24 422 110 22], ...
                    'fieldPos', [139 419 55 28], 'limits', [0.1 19], 'defaultValue', 0.1),
                struct('labelFieldName', 'C_FRCmLmbarEditFieldLabel', 'fieldName', 'input_cfrc', ...
                    'labelText', 'C_FRC [mL/mbar]', 'labelPos', [24 380 110 22], ...
                    'fieldPos', [139 377 55 28], 'limits', [1 199], 'defaultValue', 1),
                struct('labelFieldName', 'TOPmbarEditFieldLabel', 'fieldName', 'input_top', ...
                    'labelText', 'TOP [mbar]', 'labelPos', [24 333 110 22], ...
                    'fieldPos', [139 330 55 28], 'limits', [0.1 99], 'defaultValue', 0.1),
                struct('labelFieldName', 'K1mbarEditFieldLabel', 'fieldName', 'input_k', ...
                    'labelText', 'K [1/mbar]', 'labelPos', [24 285 110 22], ...
                    'fieldPos', [139 282 55 28], 'limits', [0.01 4.99], 'defaultValue', 0.01),
                struct('labelFieldName', 'RmLsmbarEditFieldLabel', 'fieldName', 'input_r', ...
                    'labelText', 'R [mL*s/mbar]', 'labelPos', [24 238 110 22], ...
                    'fieldPos', [139 235 55 28], 'limits', [0.01 4.99], 'defaultValue', 0.01),
                struct('labelFieldName', 'QmLsEditFieldLabel', 'fieldName', 'input_q', ...
                    'labelText', 'Q [mL/s]', 'labelPos', [24 185 110 22], ...
                    'fieldPos', [139 182 55 28], 'limits', [10 1999], 'defaultValue', 10),
                struct('labelFieldName', 'NEditFieldLabel', 'fieldName', 'input_n', ...
                    'labelText', 'N', 'labelPos', [24 138 110 22], ...
                    'fieldPos', [139 135 55 28], 'limits', [0 Inf], 'defaultValue', 0),
                struct('labelFieldName', 'tinspsEditFieldLabel', 'fieldName', 'input_tinsp', ...
                    'labelText', 'tinsp [s]', 'labelPos', [24 87 110 22], ...
                    'fieldPos', [139 84 55 28], 'limits', [0.01 99], 'defaultValue', 0.01)
            };
        end

        function label = createLabel(~, fig, textValue, pos, textColor)
            label = uilabel(fig);
            label.HorizontalAlignment = 'right';
            label.FontColor = textColor;
            label.Position = pos;
            label.Text = textValue;
        end

        function field = createNumericField(~, fig, limits, defaultValue, pos, bgColor, textColor, enableState)
            field = uieditfield(fig, 'numeric');
            field.Limits = limits;
            field.BackgroundColor = bgColor;
            field.FontColor = textColor;
            field.Position = pos;
            field.Value = defaultValue;
            field.Enable = enableState;
        end

        function btn = createButton(~, fig, textValue, pos, bgColor, textColor, enableState)
            if nargin < 7
                enableState = 'on';
            end
            btn = uibutton(fig, 'push');
            btn.Position = pos;
            btn.Text = textValue;
            btn.BackgroundColor = bgColor;
            btn.FontColor = textColor;
            btn.Enable = enableState;
        end

        function setButtonEnabled(obj, state)
            if isfield(obj, 'button_load'); obj.button_load.Enable = state; end
            if isfield(obj, 'button_save'); obj.button_save.Enable = state; end
            if isfield(obj, 'button_simulate'); obj.button_simulate.Enable = state; end
        end

        function setFieldEnable(obj, state)
            fields = {'input_cl', 'input_cfrc', 'input_top', 'input_k', 'input_r', 'input_q', ...
                'input_n', 'input_tinsp', 'input_sp_start', 'input_sp_steps', 'input_sp_end'};
            for i = 1:numel(fields)
                if isfield(obj, fields{i})
                    obj.(fields{i}).Enable = state;
                end
            end
            obj.setButtonEnabled(state);
        end

        function updateNLimit(obj)
            SP = obj.input_sp_start.Value:obj.input_sp_steps.Value:obj.input_sp_end.Value;
            if isempty(SP)
                return;
            end

            maxN = numel(SP);
            obj.input_n.Limits = [0 maxN];

            if obj.input_n.Value > maxN
                obj.input_n.Value = maxN;
            end
            if obj.input_n.Value < 0
                obj.input_n.Value = 0;
            end
        end

        function buttonLoadPushed(obj)
            [fileName, pathName] = uigetfile('*.mat', 'Select patient file');
            if isequal(fileName, 0)
                return;
            end

            p = LungRecruitment.Parameters.loadFromFile(fullfile(pathName, fileName));
            obj.input_top.Value = p.TOP;
            obj.input_k.Value = p.K;
            obj.input_n.Value = p.N;
            obj.input_cfrc.Value = p.Cfrc;
            obj.input_cl.Value = p.CL;
            obj.input_r.Value = p.R;
            obj.input_q.Value = p.Q;
            obj.input_tinsp.Value = p.tinsp;

            if ~isempty(p.SP)
                obj.input_sp_start.Value = p.SP(1);
                if numel(p.SP) > 1
                    obj.input_sp_steps.Value = p.SP(2) - p.SP(1);
                else
                    obj.input_sp_steps.Value = 1;
                end
                obj.input_sp_end.Value = p.SP(end);
            end

            obj.setFieldEnable('on');
            obj.input_sp_end.Enable = 'on';
            obj.input_sp_steps.Enable = 'on';
            obj.input_sp_start.Enable = 'on';
            obj.button_save.Enable = 'on';
            obj.button_simulate.Enable = 'on';
            obj.input_tinsp.Enable = 'on';
            obj.input_n.Enable = 'on';
            obj.input_q.Enable = 'on';
            obj.input_r.Enable = 'on';
            obj.input_k.Enable = 'on';
            obj.input_top.Enable = 'on';
            obj.input_cfrc.Enable = 'on';
            obj.input_cl.Enable = 'on';
            drawnow;

            obj.updateNLimit();
            obj.data = p;
        end

        function buttonSavePushed(obj)
            [fileName, pathName] = uiputfile('*.mat', 'Set filename');
            if isequal(fileName, 0)
                return;
            end
            p = LungRecruitment.Parameters.fromApp(obj);
            LungRecruitment.Parameters.saveToFile(p, fullfile(pathName, fileName));
        end

        function buttonSimulatePushed(obj)
            params = LungRecruitment.Parameters.fromApp(obj);
            [t, ~, my_paw] = LungRecruitment.Simulation.solve(params);

            cla(obj.UIAxes);
            plot(obj.UIAxes, t, my_paw, 'k', 'LineWidth', 2);
            title(obj.UIAxes, 'airway pressure');
            xlabel(obj.UIAxes, 'time [s]');
            ylabel(obj.UIAxes, 'pressure [mbar]');
            obj.UIAxes.XGrid = 'on';
            obj.UIAxes.YGrid = 'on';
            xlim(obj.UIAxes, [min(t) max(t)]);
            ylim(obj.UIAxes, [0 max(my_paw)]);
        end

        function updateButtonHover(obj, fig)
            if isempty(fig) || ~isgraphics(fig, 'figure')
                return;
            end

            requiredButtons = {'button_load', 'button_save', 'button_simulate'};
            for i = 1:numel(requiredButtons)
                if ~isfield(obj, requiredButtons{i})
                    return;
                end
            end

            pt = fig.CurrentPoint;
            for i = 1:numel(requiredButtons)
                btn = obj.(requiredButtons{i});
                if ~isgraphics(btn, 'uibutton')
                    continue;
                end

                pos = btn.Position;
                left = pos(1);
                bottom = pos(2);
                width = pos(3);
                height = pos(4);

                inside = pt(1) >= left && pt(1) <= left + width && ...
                    pt(2) >= bottom && pt(2) <= bottom + height;

                if inside
                    btn.BackgroundColor = btn.UserData.hoverBg;
                else
                    btn.BackgroundColor = btn.UserData.defaultBg;
                end
            end
        end
    end
end
