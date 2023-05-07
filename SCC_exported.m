classdef SCC_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        TabGroup            matlab.ui.container.TabGroup
        LoadDataTab         matlab.ui.container.Tab
        PredictionTextArea  matlab.ui.control.TextArea
        PredictionLabel_2   matlab.ui.control.Label
        FileName            matlab.ui.control.Label
        OptionsLabel        matlab.ui.control.Label
        DataLabel           matlab.ui.control.Label
        UploadButton        matlab.ui.control.Button
        UpdateButton        matlab.ui.control.Button
        CurrentSampleLabel  matlab.ui.control.Label
        ModelDropDown       matlab.ui.control.DropDown
        ModelLabel          matlab.ui.control.Label
        UIAxes              matlab.ui.control.UIAxes
        AboutUsTab          matlab.ui.container.Tab
        SummaryText         matlab.ui.control.TextArea
        YourDataTab         matlab.ui.container.Tab
        UITable             matlab.ui.control.Table
        PrivacyTab          matlab.ui.container.Tab
        PrivacyText         matlab.ui.control.TextArea
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: UploadButton
        function UploadButtonPushed(app, event)
            [file, path] = uigetfile('*.edf');
            app.FileName.Text = file;
            % TODO: Add code to read files here
        end

        % Button pushed function: UpdateButton
        function UpdateButtonPushed(app, event)
            eventType = app.EventTypeDropDown.Value
            model = app.ModelDropDown.Value
            shareData = app.ShareYourDataCheckBox.Value
            % TODO: Add code to display the plot and probability here
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 480];

            % Create LoadDataTab
            app.LoadDataTab = uitab(app.TabGroup);
            app.LoadDataTab.Title = 'Load Data';

            % Create UIAxes
            app.UIAxes = uiaxes(app.LoadDataTab);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.FontSize = 15;
            app.UIAxes.Position = [32 171 344 238];

            % Create ModelLabel
            app.ModelLabel = uilabel(app.LoadDataTab);
            app.ModelLabel.HorizontalAlignment = 'right';
            app.ModelLabel.FontSize = 15;
            app.ModelLabel.Position = [25 82 51 22];
            app.ModelLabel.Text = 'Model:';

            % Create ModelDropDown
            app.ModelDropDown = uidropdown(app.LoadDataTab);
            app.ModelDropDown.Items = {'SVM'};
            app.ModelDropDown.FontSize = 15;
            app.ModelDropDown.Position = [91 82 100 22];
            app.ModelDropDown.Value = 'SVM';

            % Create CurrentSampleLabel
            app.CurrentSampleLabel = uilabel(app.LoadDataTab);
            app.CurrentSampleLabel.FontSize = 24;
            app.CurrentSampleLabel.FontWeight = 'bold';
            app.CurrentSampleLabel.Position = [17 408 300 48];
            app.CurrentSampleLabel.Text = 'Current Sample';

            % Create UpdateButton
            app.UpdateButton = uibutton(app.LoadDataTab, 'push');
            app.UpdateButton.ButtonPushedFcn = createCallbackFcn(app, @UpdateButtonPushed, true);
            app.UpdateButton.FontSize = 15;
            app.UpdateButton.Position = [491 80 99 26];
            app.UpdateButton.Text = 'Update';

            % Create UploadButton
            app.UploadButton = uibutton(app.LoadDataTab, 'push');
            app.UploadButton.ButtonPushedFcn = createCallbackFcn(app, @UploadButtonPushed, true);
            app.UploadButton.FontSize = 15;
            app.UploadButton.Position = [316 80 100 26];
            app.UploadButton.Text = 'Upload';

            % Create DataLabel
            app.DataLabel = uilabel(app.LoadDataTab);
            app.DataLabel.FontSize = 15;
            app.DataLabel.Position = [260 82 41 22];
            app.DataLabel.Text = 'Data:';

            % Create OptionsLabel
            app.OptionsLabel = uilabel(app.LoadDataTab);
            app.OptionsLabel.FontSize = 18;
            app.OptionsLabel.FontWeight = 'bold';
            app.OptionsLabel.Position = [17 124 85 48];
            app.OptionsLabel.Text = 'Options';

            % Create FileName
            app.FileName = uilabel(app.LoadDataTab);
            app.FileName.HorizontalAlignment = 'center';
            app.FileName.FontColor = [1 0 0];
            app.FileName.Position = [236 40 260 22];
            app.FileName.Text = '';

            % Create PredictionLabel_2
            app.PredictionLabel_2 = uilabel(app.LoadDataTab);
            app.PredictionLabel_2.HorizontalAlignment = 'right';
            app.PredictionLabel_2.FontSize = 15;
            app.PredictionLabel_2.Position = [399 280 76 22];
            app.PredictionLabel_2.Text = 'Prediction:';

            % Create PredictionTextArea
            app.PredictionTextArea = uitextarea(app.LoadDataTab);
            app.PredictionTextArea.Editable = 'off';
            app.PredictionTextArea.FontSize = 15;
            app.PredictionTextArea.Position = [490 278 100 25];

            % Create AboutUsTab
            app.AboutUsTab = uitab(app.TabGroup);
            app.AboutUsTab.Title = 'About Us';

            % Create SummaryText
            app.SummaryText = uitextarea(app.AboutUsTab);
            app.SummaryText.Editable = 'off';
            app.SummaryText.FontSize = 18;
            app.SummaryText.Position = [64 68 512 327];
            app.SummaryText.Value = {'Our system seeks to streamline the process of detecting a seizure or concussion event from Electroencephalogram (EEG) recordings from relevant subjects. Current EEG analysis by clinicians or researchers takes a large amount of time to accurately assess, and is often subject to interindividual variation. We have designed two classifier algorithms (one for seizure detection and one for concussion) that are able to detect these characteristics from EEG recordings with high precision. Both of these classifiers can be used in the respective settings they are most appropriate for such as a clinical setting to serve as a primary or secondary option for diagnosing patients, in a research setting to save valuable time for researchers that would otherwise be spending it analyzing EEG data, or even in athletics to protect athletes from the risk of concussions by providing more support for diagnoses. '};

            % Create YourDataTab
            app.YourDataTab = uitab(app.TabGroup);
            app.YourDataTab.Title = 'Your Data';

            % Create UITable
            app.UITable = uitable(app.YourDataTab);
            app.UITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.UITable.RowName = {};
            app.UITable.Position = [47 61 523 334];

            % Create PrivacyTab
            app.PrivacyTab = uitab(app.TabGroup);
            app.PrivacyTab.Title = 'Privacy';

            % Create PrivacyText
            app.PrivacyText = uitextarea(app.PrivacyTab);
            app.PrivacyText.Editable = 'off';
            app.PrivacyText.FontSize = 18;
            app.PrivacyText.Position = [64 68 512 327];
            app.PrivacyText.Value = {'• The data we have chosen to use is specifically designed to be used for machine learning purposes in the development of high performance seizure detection algorithms. In addition, the way the data was collected was in accordance with the Declaration of Helsinki which is a formal statement of ethics that guides the protection of human participants in medical research. '; ''; '• As stated above, the way in which the data was collected was in accordance with the Declaration of Helsinki which is a formal statement of ethics that guides the protection of human participants in medical research. Thus, the rights of those who participated were protected and our implementation would further protect those rights as it’s completely voluntary for our participants.'; ''; '• Our system does not actively harm any demographics, but it does provide fewer benefits to those without access to the appropriate equipment (EEG machines). So overall, the benefits it provides outweighs the harms, as it shouldn’t have any demonstrable harms.'; ''; '• The participants for our system are treated in accordance with the Declaration of Helsinki and the full approval of the Temple University IRB. Additionally, the staff were trained in patient privacy and certified by Temple University IRB and so the participants were treated and compensated appropriately.'; ''; '• The benefits of our research will be available to all groups that have access to the internet as we are anticipating hosting our service online. This is the furthest we can go to provide our research to all demographics.'; ''; '• Our system will be providing a percentage but will recommend individuals meet with a medical professional for further analysis and a more stable guarantee. We will inform individuals that our results are not complete assurances but should be used in a supplementary manner.'; ''; '• We will aim to have our code and data all available and directly link our resources. This way individuals will be able to replicate our results and be able to develop systems further improving on what we built. Providing our information online is the most effective way to disseminate our processes and results.'};

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SCC_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end