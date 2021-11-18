% Jacob Alspaw   jaa134
% Justin Lee     jpl88
%    Final Project

function gmailSend
[unused,flag] = urlread('http://www.google.com', 'Timeout', 5);
if flag == 0
    inetWarning = msgbox('You must first connect to the internet to use this service!', 'Importing Images', 'warn');
    child = get(inetWarning, 'Children');
    delete(child(1));
    while flag == 0
        % found this method at: http://www.mathworks.com/help/matlab/ref/urlread.html
        [unused,flag] = urlread('http://www.google.com', 'Timeout', 5);
        pause(1);
        try
            set(child(3), 'FontSize', 1);
        catch
            return
        end
    end
    try
        set(child(3), 'FontSize', 1);
        delete(inetWarning);
    catch
        return
    end
end

signIn = figure('Name', 'Mail Service Tool', 'numbertitle', 'off', 'Resize','off', 'Position', [1 1 300 130], 'Visible', 'off', 'MenuBar', 'none', 'color', [0.6 0.8 0.9]);
userText = uicontrol('Style', 'text', 'Position', [5 90 55 25], 'HorizontalAlignment', 'left', 'String', 'Username: ', 'BackgroundColor', [0.6 0.8 0.9]);
userBox = uicontrol('Style', 'edit', 'Position', [70 95 225 25], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', '', 'KeyPressFcn', @userKeyPressed);
passText = uicontrol('Style', 'text', 'Position', [5 60 55 25], 'HorizontalAlignment', 'left', 'String', 'Password: ', 'BackgroundColor', [0.6 0.8 0.9]);
passBox = uicontrol('Style', 'edit', 'Position', [70 65 225 25], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', '', 'KeyPressFcn', @passKeyPressed);
serviceText = uicontrol('Style', 'text', 'Position', [5 30 55 25], 'HorizontalAlignment', 'left', 'String', 'Service: ', 'BackgroundColor', [0.6 0.8 0.9]);
serviceSelect = uicontrol('Style', 'popup', 'String', {'Aim', 'AOL', 'Comcast', 'CWRU', 'Gmail', 'Hotmail', 'iCloud', 'Outlook', 'Yahoo'}, 'Position', [70 35 225 25], 'FontSize', 12);  
submitButton = uicontrol('Style', 'pushbutton', 'String', 'Submit', 'Position',[1 1 300 25], 'Callback', @submit);
movegui(signIn, 'center');
set(signIn, 'Visible', 'on');

    function submit(varargin)
        user = get(userBox, 'String');
        pass = get(passBox, 'Userdata');
        if ~isempty(user) && ~isempty(pass)
            % we looked up how to set this property online at: http://www.mathworks.com/help/matlab/ref/sendmail.html
            setpref('Internet', 'E_mail', user);
            selection = get(serviceSelect, 'Value');
            if selection == 1
                setpref('Internet', 'SMTP_Server', 'smtp.aim.com');
            elseif selection == 2
                setpref('Internet', 'SMTP_Server', 'smtp.aol.com');
            elseif selection == 3
                setpref('Internet', 'SMTP_Server', 'smtp.comcast.net');
            elseif selection == 4
                setpref('Internet', 'SMTP_Server', 'smtp.case.edu');
            elseif selection == 5
                setpref('Internet', 'SMTP_Server', 'smtp.gmail.com');
            elseif selection == 6
                setpref('Internet', 'SMTP_Server', 'smtp.live.com');
            elseif selection == 7
                setpref('Internet', 'SMTP_Server', 'smtp.mail.me.com');
            elseif selection == 8
                setpref('Internet', 'SMTP_Server', 'smtp-mail.outlook.com');
            elseif selection == 9
                setpref('Internet', 'SMTP_Server', 'smtp.mail.yahoo.com');
            end
            setpref('Internet', 'SMTP_Username', user);
            setpref('Internet', 'SMTP_Password', pass);
            properties = java.lang.System.getProperties;
            properties.setProperty('mail.smtp.auth','true');
            properties.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
            properties.setProperty('mail.smtp.socketFactory.port','465');
            try
                loggingIn = msgbox('              Logging in...');
                sendmail('jpl88@case.edu', 'AUTHENTIFICATION', 'AUTHENTIFICATION');
            catch
                delete(loggingIn);
                userBox = uicontrol('Style', 'edit', 'Position', [70 95 225 25], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', '', 'KeyPressFcn', @userKeyPressed);
                passBox = uicontrol('Style', 'edit', 'Position', [70 65 225 25], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', '', 'KeyPressFcn', @passKeyPressed);
                warndlg('That is not an existing account!');
                return
            end
            delete(loggingIn);
            createMessageGUI(signIn);
        else
            warndlg('No field may be left blank!');
        end
    end
    
    function userKeyPressed(varargin)
        key = get(signIn,'currentkey');
        switch key
            case 'return'
                submit;
        end
    end

    function passKeyPressed(varargin)
        password = get(passBox,'Userdata');
        key = get(signIn,'currentkey');
        % we borrowed this section from online: https://www.mathworks.com/matlabcentral/newsreader/view_thread/279089
        switch key
            case 'backspace'
                password = password(1:end-1); 
                SizePass = size(password); 
                if SizePass(2) > 0
                    asterisk(1,1:SizePass(2)) = '•';
                    set(passBox,'String',asterisk) 
                else
                    set(passBox,'String','')
                end
                set(passBox,'Userdata',password)
            case 'escape'
            case 'insert'
            case 'delete'
            case 'home'
            case 'pageup'
            case 'pagedown'
            case 'end'
            case 'rightarrow'
            case 'downarrow'
            case 'leftarrow'
            case 'uparrow'
            case 'shift'
            case 'return'
                submit;
            case 'alt'
            case 'control'
            case 'windows'
            otherwise
                password = [password get(signIn,'currentcharacter')];
                SizePass = size(password); 
                if SizePass(2) > 0
                    asterisk(1:SizePass(2)) = '•'; 
                    set(passBox,'string',asterisk) 
                else
                    set(passBox,'String','');
                end
                set(passBox,'Userdata',password) ;
        end 
    end

    function createMessageGUI(signIn)
        delete(signIn);
        emailGUI = figure('Name', 'Mail Service Tool', 'numbertitle', 'off', 'Resize','off', 'Position', [1 1 750 500], 'Visible', 'off', 'MenuBar', 'none', 'color', [0.6 0.8 0.9], 'CloseRequestFcn', @createExit);
        recipientText = uicontrol('Style', 'text', 'Position', [10 460 90 30], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', 'To: ', 'BackgroundColor', [0.6 0.8 0.9]);
        recipientBox = uicontrol('Style', 'edit', 'Position', [90 460 650 30], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', '');
        subjectText = uicontrol('Style', 'text', 'Position', [10 410 90 30], 'HorizontalAlignment', 'left', 'String', 'Subject: ', 'FontSize', 14, 'BackgroundColor', [0.6 0.8 0.9]);
        subjectBox = uicontrol('Style', 'edit', 'Position', [90 410 650 30], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', '');
        messageText = uicontrol('Style', 'text', 'Position', [10 50 25 25], 'HorizontalAlignment', 'left', 'String', 'Message: ', 'FontSize', 14, 'BackgroundColor', [0.6 0.8 0.9]);
        messageBox = uicontrol('Style', 'edit', 'Position', [10 45 730 350], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', '', 'Max', 100);
        sendButton = uicontrol('Style', 'pushbutton', 'String', 'Send', 'Position',[525 10 150 25], 'FontSize', 12, 'Callback', @send);
        manageButton = uicontrol('Style', 'pushbutton', 'String', 'Manage', 'Position',[300 10 150 25], 'FontSize', 12, 'Callback', @createManageGUI);
        loadButton = uicontrol('Style', 'pushbutton', 'String', 'Load Draft', 'Position',[75 10 150 25], 'FontSize', 12, 'Callback', @loadDraft);
        movegui(emailGUI, 'center');
        set(emailGUI, 'Visible', 'on');
        attachment1 = ''; attachment2 = ''; attachment3 = ''; attachment4 = ''; attachment5 = '';
        numAttached = 0;
        
        function boolean = isAttached()
            boolean = 0;
            attachments{1} = attachment1; attachments{2} = attachment2; attachments{3} = attachment3; attachments{4} = attachment4; attachments{5} = attachment5;
            for i = 1:5
                if ~strcmp(attachments{i}, '')
                    boolean = 1;
                end
            end
        end
        
        function recieversCell = getRecipients(list)
            rNum = 1;
            startContact = 1;
            for i = 1:(length(list) - 1)
                if strcmp(list(i), ',')
                    recieversCell{rNum} = list(startContact:i-1);
                    rNum = rNum + 1;
                    startContact = i + 1;
                elseif strcmp(list(i:i+1), ', ')
                    recieversCell{rNum} = list(startContact:i-1);
                    rNum = rNum + 1;
                    startContact = i + 2;
                elseif strcmp(list(i:i+1), ',  ')
                    recieversCell{rNum} = list(startContact:i-1);
                    rNum = rNum + 1;
                    startContact = i + 3;
                elseif strcmp(list(i:i+1), ',   ')
                    recieversCell{rNum} = list(startContact:i-1);
                    rNum = rNum + 1;
                    startContact = i + 4;
                elseif strcmp(list(i:i+1), ',    ')
                    recieversCell{rNum} = list(startContact:i-1);
                    rNum = rNum + 1;
                    startContact = i + 5;
                elseif strcmp(list(i:i+1), ',     ')
                    recieversCell{rNum} = list(startContact:i-1);
                    rNum = rNum + 1;
                    startContact = i + 6;
                elseif i == (length(list) - 1)
                    recieversCell{rNum} = list(startContact:(i + 1));
                end
            end
        end
        
        function send(varargin)
            set(sendButton,'Enable','off');
            set(manageButton,'Enable','off');
            set(loadButton,'Enable','off');
            recipients = getRecipients(get(recipientBox, 'String'));
            subject = get(subjectBox, 'String');
            message = get(messageBox, 'String');
            if ~strcmp(get(recipientBox, 'String'), '') && ~strcmp(subject, '') && ~strcmp(message, '') && ~isAttached()
                try
                    sendmail(recipients, subject, message);
                    set(recipientBox, 'String', '');
                    set(subjectBox, 'String', '');
                    set(messageBox, 'String', '');
                    msgbox('               Email Sent!');
                catch
                    warndlg('      An error has occurred!');
                    set(sendButton,'Enable','on');
                    set(manageButton,'Enable','on');
                    set(loadButton,'Enable','on');
                    return
                end
            elseif ~strcmp(get(recipientBox, 'String'), '') && ~strcmp(subject, '') && ~strcmp(message, '') && isAttached()
                try
                    if numAttached == 1
                        sendmail(recipients, subject, message, attachment1);
                    elseif numAttached == 2
                        sendmail(recipients, subject, message, {attachment1; attachment2});
                    elseif numAttached == 3
                        sendmail(recipients, subject, message, {attachment1, attachment2, attachment3});
                    elseif numAttached == 4
                        sendmail(recipients, subject, message, {attachment1, attachment2, attachment3, attachment4});
                    elseif numAttached == 5
                        sendmail(recipients, subject, message, {attachment1, attachment2, attachment3, attachment4, attachment5});
                    end
                catch
                    warndlg('      An error has occurred!');
                    set(sendButton,'Enable','on');
                    set(manageButton,'Enable','on');
                    set(loadButton,'Enable','on');
                    return
                end
                set(recipientBox, 'String', '');
                set(subjectBox, 'String', '');
                set(messageBox, 'String', '');
                numAttached = 0;
                msgbox('               Email Sent!');
            else
                warndlg('No field may be left blank!');
            end
            set(sendButton,'Enable','on');
            set(manageButton,'Enable','on');
            set(loadButton,'Enable','on');
        end
        
        function loadDraft(varargin)
            set(sendButton,'Enable','off');
            set(manageButton,'Enable','off');
            set(loadButton,'Enable','off');
            [FileName, FilePath] = uigetfile('*.txt', 'Pick a draft to load.', 'drafts');
            try
                fid = fopen([FilePath, FileName], 'r');
                contents = textscan(fid, '%s %s %s', 'delimiter', '\n');
                fclose(fid);
                recipientBox = uicontrol('Style', 'edit', 'Position', [90 460 650 30], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', contents{1, 1}, 'Userdata', contents{1});
                subjectBox = uicontrol('Style', 'edit', 'Position', [90 410 650 30], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', contents{1, 2}, 'Userdata', contents{2});
                messageBox = uicontrol('Style', 'edit', 'Position', [10 45 730 350], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', contents{1, 3}, 'Userdata', contents{3}, 'Max', 100);
            catch
                msgbox('        Could not load draft!');
            end
            set(sendButton,'Enable','on');
            set(manageButton,'Enable','on');
            set(loadButton,'Enable','on');
        end
        
        function createExit(varargin)
            exitFig = figure('Name', '', 'numbertitle', 'off', 'Resize','off', 'Position', [1 1 100 115], 'Visible', 'off', 'MenuBar', 'none', 'color', [0.6 0.8 0.9]);
            logOutButton = uicontrol('Style', 'pushbutton', 'String', 'Log Out', 'Position',[10 80 115 25], 'FontSize', 12, 'Callback', @logOut);
            quitButton = uicontrol('Style', 'pushbutton', 'String', 'Quit', 'Position',[10 45 115 25], 'FontSize', 12, 'Callback', @quit);
            cancelButton = uicontrol('Style', 'pushbutton', 'String', 'Cancel', 'Position',[10 10 115 25], 'FontSize', 12, 'Callback', @cancel);
            movegui(exitFig, 'center');
            set(exitFig, 'Visible', 'on');
            
            function logOut(varargin)
                saveDraft();
                delete(exitFig);
                delete(emailGUI)
                gmailSend();
            end
            
            function quit(varargin)
                saveDraft();
                delete(exitFig);
                delete(emailGUI);
            end
            
            function cancel(varargin)
                delete(exitFig);
            end
            
            function saveDraft(varargin)
                if ~strcmp(get(recipientBox, 'String'), '') || ~strcmp(get(subjectBox, 'String'), '') || ~strcmp(get(messageBox, 'String'), '')
                    date = strrep(datestr(datetime('now')), ':', ' ');
                    fid = fopen(['drafts/Draft', date, '.txt'], 'w');
                    fprintf(fid, '%s\r\n', char(get(recipientBox, 'String')));
                    fprintf(fid, '%s\r\n', char(get(subjectBox, 'String')));
                    fprintf(fid, '%s\r\n', char(get(messageBox, 'String')));
                    fclose(fid);
                end
            end
        end
        
        manager = figure('Name', 'Google Mail Sender', 'numbertitle', 'off', 'Resize','off', 'Position', [1 1 300 100], 'Visible', 'off', 'MenuBar', 'none', 'color', [0.6 0.8 0.9], 'CloseRequestFcn', @saveManager);
        attachButton = uicontrol('Style', 'pushbutton', 'String', 'Attach File', 'Position',[75 37 150 25], 'FontSize', 12, 'Callback', @selectFile);
        file1 = ''; file2 = ''; file3 = ''; file4 = ''; file5 = '';
        detachButton1 = ''; detachButton2 = ''; detachButton3 = ''; detachButton4 = ''; detachButton5 = '';
        movegui(manager, 'center');
        
        function createManageGUI(varargin)
            set(sendButton,'Enable','off');
            set(manageButton,'Enable','off');
            set(loadButton,'Enable','off');
            set(manager, 'Visible', 'on');
        end
        
        function selectFile(varargin)
            if numAttached == 5
                warndlg('You can not attach any more items!');
                return;
            end
            d = get(0, 'screensize');
            [FileName, FilePath] = uigetfile('*.*', 'Select a file to attach.');
            try
                if FileName == 0 && FilePath == 0
                return
                end
            catch
            end
            numAttached = numAttached + 1;
            if numAttached == 1
                attachment1 = [FilePath, FileName];
                file1 = uicontrol('Style', 'text', 'HorizontalAlignment', 'left', 'FontSize', 14, 'BackgroundColor', [0.6 0.8 0.9]);
                detachButton1 = uicontrol('Style', 'pushbutton', 'String', 'Detach', 'FontSize', 12, 'Callback', @removeFile1);
                set(manager, 'Position', [(d(3)/2 - 150) (d(4)/2 - 68)  300 136]);
                set(attachButton, 'Position', [75 72 150 25]);
                set(file1, 'Position', [10 20 175 25]);
                set(file1, 'String', FileName);
                set(detachButton1, 'Position', [200 20 75 25]);
            elseif numAttached == 2
                attachment2 = [FilePath, FileName];
                file2 = uicontrol('Style', 'text', 'HorizontalAlignment', 'left', 'FontSize', 14, 'BackgroundColor', [0.6 0.8 0.9]);
                detachButton2 = uicontrol('Style', 'pushbutton', 'String', 'Detach', 'FontSize', 12, 'Callback', @removeFile2);
                set(manager, 'Position', [(d(3)/2 - 150) (d(4)/2 - 85) 300 170]);
                set(attachButton, 'Position', [75 107 150 25]);
                set(file2, 'Position', [10 55 175 25]);
                set(file2, 'String', FileName);
                set(detachButton2, 'Position', [200 55 75 25]);
            elseif numAttached == 3
                attachment3 = [FilePath, FileName];
                file3 = uicontrol('Style', 'text', 'HorizontalAlignment', 'left', 'FontSize', 14, 'BackgroundColor', [0.6 0.8 0.9]);
                detachButton3 = uicontrol('Style', 'pushbutton', 'String', 'Detach', 'FontSize', 12, 'Callback', @removeFile3);
                set(manager, 'Position', [(d(3)/2 - 150) (d(4)/2 - 103) 300 206]);
                set(attachButton, 'Position', [75 142 150 25]);
                set(file3, 'Position', [10 90 175 25]);
                set(file3, 'String', FileName);
                set(detachButton3, 'Position', [200 90 75 25]);
            elseif numAttached == 4
                attachment4 = [FilePath, FileName];
                file4 = uicontrol('Style', 'text', 'HorizontalAlignment', 'left', 'FontSize', 14, 'BackgroundColor', [0.6 0.8 0.9]);
                detachButton4 = uicontrol('Style', 'pushbutton', 'String', 'Detach', 'FontSize', 12, 'Callback', @removeFile4);
                set(manager, 'Position', [(d(3)/2 - 150) (d(4)/2 - 120) 300 240]);
                set(attachButton, 'Position', [75 177 150 25]);
                set(file4, 'Position', [10 125 175 25]);
                set(file4, 'String', FileName);
                set(detachButton4, 'Position', [200 125 75 25]);
            elseif numAttached == 5
                attachment5 = [FilePath, FileName];
                file5 = uicontrol('Style', 'text', 'HorizontalAlignment', 'left', 'FontSize', 14, 'BackgroundColor', [0.6 0.8 0.9]);
                detachButton5 = uicontrol('Style', 'pushbutton', 'String', 'Detach', 'FontSize', 12, 'Callback', @removeFile5);
                set(manager, 'Position', [(d(3)/2 - 150) (d(4)/2 - 138) 300 276]);
                set(attachButton, 'Position', [75 212 150 25]);
                set(file5, 'Position', [10 160 175 25]);
                set(file5, 'String', FileName);
                set(detachButton5, 'Position', [200 160 75 25]);
            end
        end
        
        function removeFile1(varargin)
            numAttached = numAttached - 1;
            setFigurePosition();
            attachment1 = attachment2; attachment2 = attachment3; attachment3 = attachment4; attachment4 = attachment5; attachment5 = '';
            if numAttached == 0
                delete(file1);
                delete(detachButton1);
            elseif numAttached == 1
                set(file1, 'String', get(file2, 'String'));
                delete(file2);
                delete(detachButton2);    
            elseif numAttached == 2
                set(file1, 'String', get(file2, 'String'));
                set(file2, 'String', get(file3, 'String'));
                delete(file3);
                delete(detachButton3);   
            elseif numAttached == 3
                set(file1, 'String', get(file2, 'String'));
                set(file2, 'String', get(file3, 'String'));
                set(file3, 'String', get(file4, 'String'));
                delete(file4);
                delete(detachButton4);   
            elseif numAttached == 4
                set(file1, 'String', get(file2, 'String'));
                set(file2, 'String', get(file3, 'String'));
                set(file3, 'String', get(file4, 'String'));
                set(file4, 'String', get(file5, 'String'));
                delete(file5);
                delete(detachButton5);   
            end
         end
            
        function removeFile2(varargin)
            numAttached = numAttached - 1;
            setFigurePosition();
            attachment2 = attachment3; attachment3 = attachment4; attachment4 = attachment5; attachment5 = '';
            if numAttached == 1
                delete(file2);
                delete(detachButton2);    
            elseif numAttached == 2
                set(file2, 'String', get(file3, 'String'));
                delete(file3);
                delete(detachButton3);   
            elseif numAttached == 3
                set(file2, 'String', get(file3, 'String'));
                set(file3, 'String', get(file4, 'String'));
                delete(file4);
                delete(detachButton4);   
            elseif numAttached == 4
                set(file2, 'String', get(file3, 'String'));
                set(file3, 'String', get(file4, 'String'));
                set(file4, 'String', get(file5, 'String'));
                delete(file5);
                delete(detachButton5);   
            end
        end
        
        function removeFile3(varargin)
            numAttached = numAttached - 1;
            setFigurePosition();
            attachment3 = attachment4; attachment4 = attachment5; attachment5 = '';
            if numAttached == 2
                delete(file3);
                delete(detachButton3);   
            elseif numAttached == 3
                set(file3, 'String', get(file4, 'String'));
                delete(file4);
                delete(detachButton4);   
            elseif numAttached == 4
                set(file3, 'String', get(file4, 'String'));
                set(file4, 'String', get(file5, 'String'));
                delete(file5);
                delete(detachButton5);   
            end
         end
            
         function removeFile4(varargin)
            numAttached = numAttached - 1;
            setFigurePosition();
            attachment4 = attachment5; attachment5 = '';
            if numAttached == 3
                delete(file4);
                delete(detachButton4);   
            elseif numAttached == 4
                set(file4, 'String', get(file5, 'String'));
                delete(file5);
                delete(detachButton5);   
            end
         end
         
         function removeFile5(varargin)
            numAttached = numAttached - 1;
            setFigurePosition();
            attachment5 = '';
            if numAttached == 4
                delete(file5);
                delete(detachButton5);   
            end
         end
            
        function setFigurePosition()
            d = get(0, 'screensize');
            if numAttached == 0
                set(manager, 'Position', [(d(3)/2 - 150) (d(4)/2 - 50) 300 100]);
                set(attachButton, 'Position', [75 37 150 25]);
            elseif numAttached == 1
                set(manager, 'Position', [(d(3)/2 - 150) (d(4)/2 - 68)  300 136]);
                set(attachButton, 'Position', [75 72 150 25]);
            elseif numAttached == 2
                set(manager, 'Position', [(d(3)/2 - 150) (d(4)/2 - 85) 300 170]);
                set(attachButton, 'Position', [75 107 150 25]);
            elseif numAttached == 3
                set(manager, 'Position', [(d(3)/2 - 150) (d(4)/2 - 103) 300 206]);
                set(attachButton, 'Position', [75 142 150 25]);
            elseif numAttached == 4
                set(manager, 'Position', [(d(3)/2 - 150) (d(4)/2 - 120) 300 240]);
                set(attachButton, 'Position', [75 177 150 25]);
            end
        end
            
        function saveManager(varargin)
            set(manager, 'Visible', 'off');
            set(sendButton,'Enable','on');
            set(manageButton,'Enable','on');
            set(loadButton,'Enable','on');
        end
    end
end