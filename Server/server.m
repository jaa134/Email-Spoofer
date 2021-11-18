% Jacob Alspaw       jaa134
% Justin Lee         jpl88
%       Final Project

function server
% A message board application.
app = figure('Name', 'Bubble Gum Candy Bar', 'numbertitle', 'off', 'Resize','off', 'Position', [1 1 600 350], 'Visible', 'off', 'MenuBar', 'none', 'color', 'white', 'CloseRequestFcn', @cleanSystem);
board = uicontrol('Style', 'text', 'Position', [1 50 600 302], 'HorizontalAlignment', 'left', 'String', '', 'BackgroundColor', [0.6 0.8 0.9]);
messageBox = uicontrol('Style', 'edit', 'Position', [1 1 524 50], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', '', 'KeyPressFcn', @enterPressed);
button = uicontrol('Style', 'pushbutton', 'String', 'Send', 'Position',[525 1 76 50], 'Callback', @broadcastMessage);
movegui(app, 'center');
set(app, 'Visible', 'on');
% allow a maximum of 25 connections
servers = makeServers;
% start running the application
startRunning;

    % a function to start the service
    function startRunning
        % get the servers IP address
        address = getIP();
        % display information in the message board
        set(board, 'String', {['Server IP adress is ', address]; ['Start time is ', datestr(datetime('now'))]});
        % save the chat logs periodically every 30 seconds
        chatSaver = timer('ExecutionMode','fixedRate','Period',30,'TimerFcn',@saveChat);
        start(chatSaver);
        clientUpdater = timer('ExecutionMode','fixedRate','Period',5,'TimerFcn',@updateClientChats);
        start(clientUpdater);
        while 1
            for row = 1:5
                for col = 1:5
                    fopen(servers{row, col});
                end
            end
            pause(10);
        end
    end
    
    % a function to broadcast a message to any users connected
    function broadcastMessage(source, eventdata)
        % if the users message wasnt empty
        if ~strcmp(get(messageBox, 'String'), '')
            % determine information that will be sent
            fullMessage = [datestr(datetime('now')), '   HOST:  ', get(messageBox, 'String')];
            % change the local message board
            set(board, 'String', {char(get(board, 'String')); fullMessage});
            % clear the message box
            messageBox = uicontrol('Style', 'edit', 'Position', [1 1 524 50], 'HorizontalAlignment', 'left', 'FontSize', 14, 'String', '', 'KeyPressFcn', @enterPressed);
            % have cursor reselect message box
            uicontrol(messageBox);
        end
    end
    
    % a function to save the chat logs
    function saveChat(source, eventdata)
        % find the chat
        chat = get(board, 'String');
        % get size of chat
        [nRows, nCols] = size(chat);
        % determine the name of the master copy
        masterName = sprintf('master log %s.txt ', strrep(datestr(datetime('now')), ':', ' '));
        % open the file for editing
        fid = fopen(masterName, 'w');
        % go through each row of the chat
        for row = 1:nRows
            % save the chat into file
            fprintf(fid, '%s\r\n', chat{row,:});
        end
        % close the file
        fclose(fid);
        % determine the name of the extra copy
        copyName = sprintf('copy log %s.txt ', strrep(datestr(datetime('now')), ':', ' '));
        % open the file for editing
        fid = fopen(copyName, 'w');
        % go through each row of the chat
        for row = 1:nRows
            % save the chat into file
            fprintf(fid, '%s\r\n', chat{row,:});
        end
        % close the file
        fclose(fid);
        % tell user that chat has been saved
        disp('Saved Chat Log!');
    end
    
    % a function to get the ip address of the user's machine. WINDOWS SPECIFIC!!!
    function ip = getIP()
        % store the result of the temrinal command 
        [status, result] = system('ipconfig');
        % mark the front of the ip address
        beginning = strfind(result, 'IPv4 Address. . . . . . . . . . . : ');
        % mark the end of the ip address
        ending = strfind(result, 'Subnet Mask . . . . . . . . . . . : ');
        % make the ip storing characters using above edge locations
        ip = [];
        for i = beginning(1)+36:ending(1)-5
            ip = [ip, result(i)];
        end
    end
    
    % a function to watch if the user presses enter key inside of the message box
    function enterPressed(source, eventdata)
        % store the key pressed in the message box
        pressedKey = get(app,'CurrentCharacter');
        % if the key was the equals key
        if isequal(pressedKey, char(13))
            % send the message to all users
           broadcastMessage;
        end
    end

    % a function to open 25 tcpip server connections
    function servers = makeServers
        % make 25 cells to store 25 servers
        servers = cell(5);
        % initial server set to number 1
        serverNum = 1;
        % fill each cell with a new server ready for connection
        for row = 1:5
            for col = 1:5
                % determine the server's port number
                portNum = 45000 + serverNum;
                % create the server over port 55000 allowing any IP adresses connection
                servers{row, col} = tcpip('0.0.0.0', portNum, 'NetworkRole', 'Server');
                % increment the server number
                serverNum = serverNum +1; 
            end
        end
    end
    
    % a function to close connections and delete the app
    function cleanSystem(source, eventdata)
        % go through each cell
        for row = 1:5
            for col = 1:5
                % close the server in the current cell position
                fclose(servers{row, col});
            end
        end
        % close the GUI
        delete(app);
    end

    % a function to update clients chats
    function updateClientChats(source, eventdata)
        % go through each cell position
        for row = 1:5
            for col = 1:5
                % send the chat as a cell array
                fprintf(servers{row, col}, '%s', char(get(board, 'String')));
            end
        end
    end

% THINGS TO ADD
%     recieve message over netowrk
end