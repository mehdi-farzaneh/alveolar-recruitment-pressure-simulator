classdef Theme
    % UI theme definitions for the alveolar recruitment app.

    methods (Static)
        function theme = getTheme()
            % Light, user-friendly palette for the GUI.
            theme.figureBg = [0.96 0.97 0.99];
            theme.panelBg = [0.94 0.96 0.98];
            theme.axesBg = [1 1 1];
            theme.fieldBg = [1 1 1];
            theme.fieldText = [0.10 0.15 0.22];
            theme.text = [0.16 0.22 0.30];
            theme.grid = [0.82 0.86 0.90];
            theme.button = [0.22 0.62 0.84];
            theme.buttonHover = [0.13 0.55 0.92];
            theme.buttonPressed = [0.10 0.45 0.78];
            theme.buttonText = [1 1 1];
        end
    end
end
