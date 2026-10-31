function alveolarRecruitmentGUI
    % Entry point for the alveolar recruitment and airway pressure simulator.
    app = LungRecruitment.UI();
    waitfor(app.UIFigure);
end
