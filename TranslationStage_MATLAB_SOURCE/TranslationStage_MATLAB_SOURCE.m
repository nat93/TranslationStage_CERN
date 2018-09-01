%% MATLAB GUI to control translation stage for UA9 experiment
%
% *Author:* Andrii Natochii
% 
% *Email:* andrii.natochii@cern.ch
% 
%
%
% *CERN 2018*
%% Main function TranslationStage_MATLAB_SOURCE() without arguments
function TranslationStage_MATLAB_SOURCE()
%% Create GUI elements
% Creating main figure for all other components
f = figure('Visible','off','Name',...
    'Translation stage for UA9 experiment',...
    'Position',[450,200,800,600]);
set(f, 'NumberTitle', 'off');
set(f, 'MenuBar', 'none');
set(f, 'ToolBar', 'none');
%% TCP-IP panel
tcp_ip_panel = uipanel('Parent',f,'Title','TPC/IP connection',...
    'FontSize',10,'Position',[0.01 0.8 0.48 0.2]);
% IP1
checkbox1 = uicontrol(tcp_ip_panel,'Style','checkbox','String','MCB-1',...
    'Value',0,'Units','normalized','Position',[0.01 0.8 0.2 0.2],...
    'Callback',{@checkbox1_Callback});
set(checkbox1,'FontSize',10);
set(checkbox1,'Value',0);
ip1_wind = uicontrol(tcp_ip_panel,'Style','edit','String',...
    '172.26.28.197','FontSize',10,'Units','normalized',...
    'BackgroundColor','w','Position',[0.43 0.8 0.56 0.2]);
ip1_string = sprintf('Device IP address');
set(ip1_wind,'TooltipString',ip1_string);
% IP2
checkbox2 = uicontrol(tcp_ip_panel,'Style','checkbox','String','MCB-2',...
    'Value',0,'Units','normalized','Position',[0.01 0.55 0.2 0.2],...
    'Callback',{@checkbox2_Callback});
set(checkbox2,'FontSize',10);
set(checkbox2,'Value',1);
ip2_wind = uicontrol(tcp_ip_panel,'Style','edit','String',...
    '172.26.26.210','FontSize',10,'Units','normalized',...
    'BackgroundColor','w','Position',[0.43 0.55 0.56 0.2]);
ip2_string = sprintf('Device IP address');
set(ip2_wind,'TooltipString',ip2_string);
% Connection Button
connect_button = uicontrol(tcp_ip_panel,'Style','pushbutton',...
    'String','Connect','FontSize',10,'Units','normalized',...
    'Position',[0.01,0.1,0.2,0.3],'BackgroundColor','g',...
    'Callback',{@connectbutton_Callback});
connect_string = sprintf('Press for TCP/IP connection');
set(connect_button,'TooltipString',connect_string);
% Disconnection Button
disconnect_button = uicontrol(tcp_ip_panel,'Style','pushbutton',...
    'String','Disconnect','FontSize',10,'Units','normalized',...
    'Position',[0.22,0.1,0.2,0.3],'BackgroundColor','r',...
    'Callback',{@disconnectbutton_Callback});
disconnect_string = sprintf('Press for TCP/IP disconnection');
set(disconnect_button,'TooltipString',disconnect_string);
set(disconnect_button,'Enable','off');
% Connection status window
connect_wind = uicontrol(tcp_ip_panel,'Style','edit','String',...
    'Disconnected.','FontSize',10,'Units','normalized',...
    'BackgroundColor','w','Position',[0.43 0.1 0.56 0.3]);
% Connection status
connection = false;
%% TABs
tab_panel = uipanel('Parent',f,'Title','Stage Control Panel',...
    'FontSize',10,'Units','normalized','Position',[0.01 0.15 0.48 0.65]);
tgroup = uitabgroup('Parent', tab_panel);
tab1 = uitab('Parent', tgroup, 'Title', 'Double TS');
tab2 = uitab('Parent', tgroup, 'Title', 'Single TS');
tab1.ForegroundColor = 'blue';
tab1.BackgroundColor = [0.8 0.8 0.8];
tab2.ForegroundColor = 'blue';
tab2.BackgroundColor = [0.8 0.8 0.8];
tgroup.SelectedTab = tab1;
%% TAB1
%% Motor I panel
% Motor panel with all necessary buttons for motor 1 controlling
motor1panel = uipanel('Parent',tab1,'Title','Motor I (-)','FontSize',10,...
    'Units','normalized','Position',[0.01 0.655 0.98 0.33]);
% Enabling button
enable1_button = uicontrol(motor1panel,'Style','pushbutton',...
    'String','Enable','Units','normalized','Position',[0.01 0.45 0.2 0.2],...
    'FontSize',10,'Callback',{@enable1button_Callback});
enable1_string = sprintf('Press to Enable Motor I');
set(enable1_button,'TooltipString',enable1_string);
% Disabling button
disable1_button = uicontrol(motor1panel,'Style','pushbutton',...
    'String','Disable','Units','normalized','Position',[0.01 0.65 0.2 0.2],...
    'FontSize',10,'Callback',{@disable1button_Callback});
disable1_string = sprintf('Press to Disable Motor I');
set(disable1_button,'TooltipString',disable1_string);
% Starting Button
start1_button = uicontrol(motor1panel,'Style','pushbutton',...
    'String','Start','Units','normalized','Position',[0.21 0.65 0.2 0.2],...
    'FontSize',10,'Callback',{@start1button_Callback});
start1_string = sprintf('Press to Start moving Motor I');
set(start1_button,'TooltipString',start1_string);
% Stopping Button
stop1_button = uicontrol(motor1panel,'Style','pushbutton',...
    'String','Stop','Units','normalized','Position',[0.21 0.45 0.2 0.2],...
    'FontSize',10,'Callback',{@stop1button_Callback});
stop1_string = sprintf('Press to Stop moving Motor I');
set(stop1_button,'TooltipString',stop1_string);
%
speed1_text = uicontrol(motor1panel,'Style','text','String',...
    'Speed [mm/sec]:','Units','normalized',...
    'Position',[0.41 0.65 0.4 0.16]);
set(speed1_text,'FontSize',10);
% Speed window
speed1_wind = uicontrol(motor1panel,'Style','edit','String','1.0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.65 0.18 0.15]);
speed1_string = sprintf('More than 0.0025 mm/sec \nLess than 10.0 mm/s');
set(speed1_wind,'TooltipString',speed1_string);
%
acc1_text = uicontrol(motor1panel,'Style','text','String',...
    'Acceleration [mm/sec/sec]:','Units','normalized',...
    'Position',[0.41 0.45 0.4 0.16]);
set(acc1_text,'FontSize',10);
% Acceleration window
acc1_wind = uicontrol(motor1panel,'Style','edit','String','0.25',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.45 0.18 0.15]);
acc1_string = sprintf('More than 0.0025 mm/sec/sec \nLess than Speed value');
set(acc1_wind,'TooltipString',acc1_string);
% Button for setting current position of the motor
setcurpos1_button = uicontrol(motor1panel,'Style','pushbutton',...
    'String','Set Current Position','Units','normalized',...
    'FontSize',10,'Position',[0.01 0.25 0.4 0.2],...
    'Callback',{@setcurpos1button_Callback});
setcurpos1_string = sprintf('Press for setting motor current position');
set(setcurpos1_button,'TooltipString',setcurpos1_string);
%
curpos1_text = uicontrol(motor1panel,'Style','text','String',...
    'Position [mm]:','Units','normalized',...
    'Position',[0.41 0.25 0.4 0.16]);
set(curpos1_text,'FontSize',10);
% Window for current position value
curpos1_wind = uicontrol(motor1panel,'Style','edit','String','0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.25 0.18 0.15]);
curpos1_string = sprintf('Be sure that position is correct');
set(curpos1_wind,'TooltipString',curpos1_string);
% Button for setting target position of the motor
settargpos1_button = uicontrol(motor1panel,'Style','pushbutton',...
    'String','Set Target Position','Units','normalized',...
    'FontSize',10,'Position',[0.01 0.05 0.4 0.2],...
    'Callback',{@settargpos1button_Callback});
settargpos1_string = sprintf('Press for setting motor target position');
set(settargpos1_button,'TooltipString',settargpos1_string);
%
targ1_text = uicontrol(motor1panel,'Style','text','String',...
    'Position [mm]:','Units','normalized',...
    'Position',[0.41 0.05 0.4 0.16]);
set(targ1_text,'FontSize',10);
% Window for target position value
targpos1_wind = uicontrol(motor1panel,'Style','edit','String','0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.05 0.18 0.15]);
targpos1_string = sprintf('Be sure that position is correct');
set(targpos1_wind,'TooltipString',targpos1_string);
% Value of target position, global variable
targetpos1 = str2double(get(targpos1_wind,'String')); 
% Enabling status
enable1 = false;
% Status of moving and starting
start1 = false;
% Target status
target1 = false;

%% Motor II panel
% Motor panel with all necessary buttons for motor 1 controlling
motor2panel = uipanel('Parent',tab1,'Title','Motor II (+)','FontSize',10,...
    'Units','normalized','Position',[0.01 0.320 0.98 0.33]);
% Enabling button
enable2_button = uicontrol(motor2panel,'Style','pushbutton',...
    'String','Enable','Units','normalized','Position',[0.01 0.45 0.2 0.2],...
    'FontSize',10,'Callback',{@enable2button_Callback});
enable2_string = sprintf('Press to Enable Motor II');
set(enable2_button,'TooltipString',enable2_string);
% Disabling button
disable2_button = uicontrol(motor2panel,'Style','pushbutton',...
    'String','Disable','Units','normalized','Position',[0.01 0.65 0.2 0.2],...
    'FontSize',10,'Callback',{@disable2button_Callback});
disable2_string = sprintf('Press to Disable Motor II');
set(disable2_button,'TooltipString',disable2_string);
% Starting Button
start2_button = uicontrol(motor2panel,'Style','pushbutton',...
    'String','Start','Units','normalized','Position',[0.21 0.65 0.2 0.2],...
    'FontSize',10,'Callback',{@start2button_Callback});
start2_string = sprintf('Press to Start moving Motor II');
set(start2_button,'TooltipString',start2_string);
% Stopping Button
stop2_button = uicontrol(motor2panel,'Style','pushbutton',...
    'String','Stop','Units','normalized','Position',[0.21 0.45 0.2 0.2],...
    'FontSize',10,'Callback',{@stop2button_Callback});
stop2_string = sprintf('Press to Stop moving Motor II');
set(stop2_button,'TooltipString',stop2_string);
% 
speed2_text = uicontrol(motor2panel,'Style','text','String',...
    'Speed [mm/sec]:','Units','normalized',...
    'Position',[0.41 0.65 0.4 0.16]);
set(speed2_text,'FontSize',10);
% Speed window
speed2_wind = uicontrol(motor2panel,'Style','edit','String','1.0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.65 0.18 0.15]);
speed2_string = sprintf('More than 0.0025 mm/sec \nLess than 10.0 mm/s');
set(speed2_wind,'TooltipString',speed2_string);
%
acc2_text = uicontrol(motor2panel,'Style','text','String',...
    'Acceleration [mm/sec/sec]:','Units','normalized',...
    'Position',[0.41 0.45 0.4 0.16]);
set(acc2_text,'FontSize',10);
% Acceleration window
acc2_wind = uicontrol(motor2panel,'Style','edit','String','0.25',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.45 0.18 0.15]);
acc2_string = sprintf('More than 0.0025 mm/sec/sec \nLess than Speed value');
set(acc2_wind,'TooltipString',acc2_string);
% Button for setting current position of the motor
setcurpos2_button = uicontrol(motor2panel,'Style','pushbutton',...
    'String','Set Current Position','Units','normalized',...
    'FontSize',10,'Position',[0.01 0.25 0.4 0.2],...
    'Callback',{@setcurpos2button_Callback});
setcurpos2_string = sprintf('Press for setting motor current position');
set(setcurpos2_button,'TooltipString',setcurpos2_string);
%
curpos2_text = uicontrol(motor2panel,'Style','text','String',...
    'Position [mm]:','Units','normalized',...
    'Position',[0.41 0.25 0.4 0.16]);
set(curpos2_text,'FontSize',10);
% Window for current position value
curpos2_wind = uicontrol(motor2panel,'Style','edit','String','0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.25 0.18 0.15]);
curpos2_string = sprintf('Be sure that position is correct');
set(curpos2_wind,'TooltipString',curpos2_string);
% Button for setting target position of the motor
settargpos2_button = uicontrol(motor2panel,'Style','pushbutton',...
    'String','Set Target Position','Units','normalized',...
    'FontSize',10,'Position',[0.01 0.05 0.4 0.2],...
    'Callback',{@settargpos2button_Callback});
settargpos2_string = sprintf('Press for setting motor target position');
set(settargpos2_button,'TooltipString',settargpos2_string);
%
targ2_text = uicontrol(motor2panel,'Style','text','String',...
    'Position [mm]:','Units','normalized',...
    'Position',[0.41 0.05 0.4 0.16]);
set(targ2_text,'FontSize',10);
% Window for target position value
targpos2_wind = uicontrol(motor2panel,'Style','edit','String','0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.05 0.18 0.15]);
targpos2_string = sprintf('Be sure that position is correct');
set(targpos2_wind,'TooltipString',targpos2_string);
% Value of target position, global variable
targetpos2 = str2double(get(targpos2_wind,'String')); 
% Enabling status
enable2 = false;
% Status of moving and starting
start2 = false;
% Target status
target2 = false;

%% Beam panel
beam_panel = uipanel('Parent',tab1,'Title','Beam Position',...
    'FontSize',10,'Position',[0.01 0.215 0.98 0.10]);
% Set Button
set_beam_button = uicontrol(beam_panel,'Style','pushbutton',...
    'String','Set New','FontSize',10,'Units','normalized',...
    'Position',[0.01,0.1,0.2,0.7],...
    'Callback',{@setbeambutton_Callback});
set_beam_string = sprintf('Press to set beam position');
set(set_beam_button,'TooltipString',set_beam_string);
% Get Button
get_beam_button = uicontrol(beam_panel,'Style','pushbutton',...
    'String','Get Previous','FontSize',10,'Units','normalized',...
    'Position',[0.21,0.1,0.2,0.7],...
    'Callback',{@getbeambutton_Callback});
get_beam_string = sprintf('Press to get beam position from logfile');
set(get_beam_button,'TooltipString',get_beam_string);
%
beam_text = uicontrol(beam_panel,'Style','text','String',...
    'Position [mm]:','Units','normalized',...
    'Position',[0.41 0.1 0.4 0.7]);
set(beam_text,'FontSize',10);
% Window
beam_wind = uicontrol(beam_panel,'Style','edit','String','0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.1 0.18 0.7]);
beam_wind_string = sprintf('Be sure that the value is correct');
set(beam_wind,'TooltipString',beam_wind_string);
%% Gap panel
gap_panel = uipanel('Parent',tab1,'Title','Gap Limitation',...
    'FontSize',10,'Position',[0.01 0.01 0.98 0.20]);

radio_button_group = uibuttongroup(gap_panel,'Visible','off','Units','normalized',...
    'Position',[0.01 0.55 0.4 0.4]);
% Create three radio buttons in the button group.
% OFF
radio_button_2 = uicontrol(radio_button_group,'Style','radiobutton',...
    'FontSize',10,'String','OFF','Tag','OFF','Units','normalized',...
    'Position',[0.01 0.1 0.48 0.8],'HandleVisibility','off');
% ON 
radio_button_1 = uicontrol(radio_button_group,'Style','radiobutton',...
    'FontSize',10,'String','ON','Tag','ON','Units','normalized',...
    'Position',[0.51 0.1 0.48 0.8],'HandleVisibility','off');
radio_button_1_string = sprintf('Choose to enable gap limitation');
set(radio_button_1,'TooltipString',radio_button_1_string);
radio_button_2_string = sprintf('Choose to disable gap limitation');
set(radio_button_2,'TooltipString',radio_button_2_string);             
% Make the uibuttongroup visible after creating child objects. 
set(radio_button_group, 'SelectionChangeFcn',@radiobuttonsselection);
set(radio_button_group, 'Visible','on');

gap_text_1 = uicontrol(gap_panel,'Style','text','String',...
    'Current gap [mm]:','Units','normalized',...
    'Position',[0.42 0.55 0.4 0.4]);
set(gap_text_1,'FontSize',10);
% Window for gap value
gap_wind_1 = uicontrol(gap_panel,'Style','edit','String','0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.55 0.18 0.4]);
gap_wind_string_1 = sprintf('Current value of the gap');
set(gap_wind_1,'TooltipString',gap_wind_string_1);

gap_text_2 = uicontrol(gap_panel,'Style','text','String',...
    'Gap limit [mm]:','Units','normalized',...
    'Position',[0.42 0.05 0.4 0.4]);
set(gap_text_2,'FontSize',10);
% Window for gap limit
gap_wind_2 = uicontrol(gap_panel,'Style','edit','String','0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.05 0.18 0.4]);
gap_wind_string_2 = sprintf('Current value of the gap limit');
set(gap_wind_2,'TooltipString',gap_wind_string_2);

% Set Button
set_gap_button = uicontrol(gap_panel,'Style','pushbutton',...
    'String','Set New','FontSize',10,'Units','normalized',...
    'Position',[0.01,0.1,0.2,0.4],...
    'Callback',{@setgapbutton_Callback});
set_gap_string = sprintf('Press to set gap value');
set(set_gap_button,'TooltipString',set_gap_string);
% Get Button
get_gap_button = uicontrol(gap_panel,'Style','pushbutton',...
    'String','Get Previous','FontSize',10,'Units','normalized',...
    'Position',[0.21,0.1,0.2,0.4],...
    'Callback',{@getgapbutton_Callback});
get_gap_string = sprintf('Press to get gap value from logfile');
set(get_gap_button,'TooltipString',get_gap_string);

set(gap_wind_1,'Enable','off');
set(gap_wind_2,'Enable','off');
set(set_gap_button,'Enable','off');
set(get_gap_button,'Enable','off');

gat_switch_status = false;
gat_limit_value = 0;

%% TAB2
%% Motor III panel
% Motor panel with all necessary buttons for motor controlling
motor3panel = uipanel('Parent',tab2,'Title','Motor III','FontSize',10,...
    'Units','normalized','Position',[0.01 0.01 0.98 0.98]);
% Enabling button
enable3_button = uicontrol(motor3panel,'Style','pushbutton',...
    'String','Enable','Units','normalized','Position',[0.01 0.65 0.2 0.1],...
    'FontSize',10,'Callback',{@enable3button_Callback});
enable3_string = sprintf('Press to Enable Motor III');
set(enable3_button,'TooltipString',enable3_string);
% Disabling button
disable3_button = uicontrol(motor3panel,'Style','pushbutton',...
    'String','Disable','Units','normalized','Position',[0.01 0.85 0.2 0.1],...
    'FontSize',10,'Callback',{@disable3button_Callback});
disable3_string = sprintf('Press to Disable Motor III');
set(disable3_button,'TooltipString',disable3_string);
% Starting Button
start3_button = uicontrol(motor3panel,'Style','pushbutton',...
    'String','Start','Units','normalized','Position',[0.21 0.85 0.2 0.1],...
    'FontSize',10,'Callback',{@start3button_Callback});
start3_string = sprintf('Press to Start moving Motor III');
set(start3_button,'TooltipString',start3_string);
% Stopping Button
stop3_button = uicontrol(motor3panel,'Style','pushbutton',...
    'String','Stop','Units','normalized','Position',[0.21 0.65 0.2 0.1],...
    'FontSize',10,'Callback',{@stop3button_Callback});
stop3_string = sprintf('Press to Stop moving Motor III');
set(stop3_button,'TooltipString',stop3_string);
%
speed3_text = uicontrol(motor3panel,'Style','text','String',...
    'Speed [mm/sec]:','Units','normalized',...
    'Position',[0.41 0.85 0.4 0.08]);
set(speed3_text,'FontSize',10);
% Speed window
speed3_wind = uicontrol(motor3panel,'Style','edit','String','1.0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.85 0.18 0.075]);
speed3_string = sprintf('More than 0.0025 mm/sec \nLess than 10.0 mm/s');
set(speed3_wind,'TooltipString',speed3_string);
%
acc3_text = uicontrol(motor3panel,'Style','text','String',...
    'Acceleration [mm/sec/sec]:','Units','normalized',...
    'Position',[0.41 0.65 0.4 0.08]);
set(acc3_text,'FontSize',10);
% Acceleration window
acc3_wind = uicontrol(motor3panel,'Style','edit','String','0.25',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.65 0.18 0.075]);
acc3_string = sprintf('More than 0.0025 mm/sec/sec \nLess than Speed value');
set(acc3_wind,'TooltipString',acc3_string);
% Button for setting current position of the motor
setcurpos3_button = uicontrol(motor3panel,'Style','pushbutton',...
    'String','Set Current Position','Units','normalized',...
    'FontSize',10,'Position',[0.01 0.45 0.4 0.1],...
    'Callback',{@setcurpos3button_Callback});
setcurpos3_string = sprintf('Press for setting motor current position');
set(setcurpos3_button,'TooltipString',setcurpos3_string);
%
curpos3_text = uicontrol(motor3panel,'Style','text','String',...
    'Position [mm]:','Units','normalized',...
    'Position',[0.41 0.45 0.4 0.08]);
set(curpos3_text,'FontSize',10);
% Window for current position value
curpos3_wind = uicontrol(motor3panel,'Style','edit','String','0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.45 0.18 0.075]);
curpos3_string = sprintf('Be sure that position is correct');
set(curpos3_wind,'TooltipString',curpos3_string);
% Button for setting target position of the motor
settargpos3_button = uicontrol(motor3panel,'Style','pushbutton',...
    'String','Set Target Position','Units','normalized',...
    'FontSize',10,'Position',[0.01 0.25 0.4 0.1],...
    'Callback',{@settargpos3button_Callback});
settargpos3_string = sprintf('Press for setting motor target position');
set(settargpos3_button,'TooltipString',settargpos3_string);
%
targ3_text = uicontrol(motor3panel,'Style','text','String',...
    'Position [mm]:','Units','normalized',...
    'Position',[0.41 0.25 0.4 0.08]);
set(targ3_text,'FontSize',10);
% Window for target position value
targpos3_wind = uicontrol(motor3panel,'Style','edit','String','0',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.81 0.25 0.18 0.075]);
targpos3_string = sprintf('Be sure that position is correct');
set(targpos3_wind,'TooltipString',targpos3_string);

% Checkbox for scanning mode
checkbox3 = uicontrol(motor3panel,'Style','checkbox','String',...
    'Scan mode','Value',0,'Units','normalized',...
    'Position',[0.01 0.05 0.2 0.05],'Callback',{@checkbox3_Callback});
% low limit
lowlimit3_text = uicontrol(motor3panel,'Style','text','String',...
    'Low limit:','Units','normalized',...
    'Position',[0.21 0.1 0.15 0.05]);
set(lowlimit3_text,'FontSize',10);
lowlimit3_wind = uicontrol(motor3panel,'Style','edit','String','-10',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.21 0.01 0.15 0.075]);
lowlimit3_string = sprintf('Low limit of the scanning range (in mm)');
set(lowlimit3_wind,'TooltipString',lowlimit3_string);
% high limit
highlimit3_text = uicontrol(motor3panel,'Style','text','String',...
    'High limit:','Units','normalized',...
    'Position',[0.37 0.1 0.15 0.05]);
set(highlimit3_text,'FontSize',10);
highlimit3_wind = uicontrol(motor3panel,'Style','edit','String','10',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.37 0.01 0.15 0.075]);
highlimit3_string = sprintf('High limit of the scanning range (in mm)');
set(highlimit3_wind,'TooltipString',highlimit3_string);
% number of points
npoints3_text = uicontrol(motor3panel,'Style','text','String',...
    'N points:','Units','normalized',...
    'Position',[0.53 0.1 0.15 0.05]);
set(npoints3_text,'FontSize',10);
npoints3_wind = uicontrol(motor3panel,'Style','edit','String','5',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.53 0.01 0.15 0.075]);
npoints3_string = sprintf('The number of points for scanning (> 0, integer)');
set(npoints3_wind,'TooltipString',npoints3_string);
% pause
pause3_text = uicontrol(motor3panel,'Style','text','String',...
    'Pause:','Units','normalized',...
    'Position',[0.69 0.1 0.15 0.05]);
set(pause3_text,'FontSize',10);
pause3_wind = uicontrol(motor3panel,'Style','edit','String','60',...
    'FontSize',10,'BackgroundColor','w','Units','normalized',...
    'Position',[0.69 0.01 0.15 0.075]);
pause3_string = sprintf('Waiting time in each point (> 0, in sec)');
set(pause3_wind,'TooltipString',pause3_string);

% Value of target position, global variable
targetpos3 = str2double(get(targpos3_wind,'String')); 
% Enabling status
enable3 = false;
% Status of moving and starting
start3 = false;
% Target status
target3 = false;
% Checkbox status
scanmode3 = get(checkbox3,'Value');

%% Enabling of the buttons
set(enable1_button,'Enable','on');
set(enable2_button,'Enable','on');

set(disable1_button,'Enable','off');
set(disable2_button,'Enable','off');
set(start1_button,'Enable','off');
set(start2_button,'Enable','off');
set(stop1_button,'Enable','off');
set(stop2_button,'Enable','off');

if get(checkbox2,'Value')
    set(enable3_button,'Enable','on');
    
    set(disable3_button,'Enable','off');                    
    set(start3_button,'Enable','off');                    
    set(stop3_button,'Enable','off');                    
end
%% Common STOP button
stop_button = uicontrol(f,'Style','pushbutton','BackgroundColor','r',...
    'String','STOP','Units','normalized','Position',[0.01 0.095 0.48 0.05],...
    'FontSize',10,'Callback',{@stopbutton_Callback});
stop_string = sprintf('Press to stop all motors');
set(stop_button,'TooltipString',stop_string);
%% Log Panel
logpanel = uipanel('Parent',f,'Title','Log window',...
    'FontSize',10,'Units','normalized','Position',[0.51 0.15 0.48 0.85]);
log_wind = uicontrol(logpanel,'Style','list','FontSize',10,...
    'Units','normalized','BackgroundColor','k','ForegroundColor','w',...
    'Position',[0.01 0.01 0.98 0.98]);
set(log_wind,'String',...
    [datestr(now,'mmmm dd, yyyy HH:MM:SS AM') ' :: New session.']);
%% Signature
signature_text = uicontrol('Parent',f,'Style','text','String',...
    [datestr(now,'mmmm dd, yyyy HH:MM:SS AM') ' (UA9 CERN)'],'FontAngle','italic',...
    'Units','normalized','Position',[0.01 0.01 0.48 0.04]);
set(signature_text,'FontSize',10);
%% Help button
help_button = uicontrol(f,'Style','pushbutton','String','Help',...
    'Units','normalized','Position',[0.89 0.095 0.1 0.05],...
    'FontSize',10,'Callback',{@helpbutton_Callback});
help_string = sprintf('Press to see the help information');
set(help_button,'TooltipString',help_string);
%% Get status button
status_button = uicontrol(f,'Style','pushbutton','String','Get Status',...
    'Units','normalized','Position',[0.79 0.095 0.1 0.05],...
    'FontSize',10,'Callback',{@statusbutton_Callback});
status_string = sprintf('Press to see the current system status');
set(status_button,'TooltipString',status_string);
%%
movegui(f,'center');
set(f,'Visible','on');
%% TCPIP obj
% Wait bar to chenge ip address if need
h = waitbar(0,'Please wait...');
set(h,'NumberTitle','off');
set(h, 'MenuBar', 'none');
set(h, 'ToolBar', 'none');
steps = 2000;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h) 
%Creates a TCPIP object = t, associated with remote host = 80.
t = tcpip(get(ip2_wind,'String'), 80);
exist_t = true;
%% Log file obj
% Open file to write the motors position
filenameLOG = 'logfile_TranslationStage_CERN.txt';
fid = fopen(fullfile(pwd,filenameLOG),'a+');

fprintf(fid, '%s :: New session.\n',...
    datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Log file location: ' fullfile(pwd,filenameLOG)]}));
%% Conversion coefficients
LperR = 4.0;        % [mm/r]
SperR = 1000.0;     % [stp/r]
mm2steps = SperR/LperR;
steps2mm = LperR/SperR;
%% Description of the button functions
%% CHECKBOX TS-1
    function checkbox1_Callback(~,~,~)
        checkbox1_status = get(checkbox1,'Value');
        set(checkbox2,'Value',~checkbox1_status);
        
        if checkbox1_status
            tab2.Title = 'Empty';
            tab2.ForegroundColor = 'red';
            
            set(enable3_button,'Enable','off');
            set(disable3_button,'Enable','off');
            set(start3_button,'Enable','off');
            set(stop3_button,'Enable','off');            
        else
            tab2.Title = 'Single TS';
            tab2.ForegroundColor = 'blue';
            
            set(enable3_button,'Enable','on');
            set(disable3_button,'Enable','on');
            set(start3_button,'Enable','on');
            set(stop3_button,'Enable','on');
        end
    end
%% CHECKBOX TS-2
    function checkbox2_Callback(~,~,~)        
        checkbox2_status = get(checkbox2,'Value');
        set(checkbox1,'Value',~checkbox2_status);
        
        if ~checkbox2_status
            tab2.Title = 'Empty';
            tab2.ForegroundColor = 'red';
            
            set(sw1_button,'Enable','off');
            set(sw2_button,'Enable','off');
            set(enable3_button,'Enable','off');
            set(disable3_button,'Enable','off');
            set(start3_button,'Enable','off');
            set(stop3_button,'Enable','off');            
        else
            tab2.Title = 'Single TS';
            tab2.ForegroundColor = 'blue';

            set(enable3_button,'Enable','on');
            set(disable3_button,'Enable','on');
            set(start3_button,'Enable','on');
            set(stop3_button,'Enable','on');
        end
    end
%% CONNECT
    function connectbutton_Callback(~,~,~)
        set(checkbox1,'Enable','off');
        set(checkbox2,'Enable','off');
        set(connect_button,'Enable','off');
        set(disconnect_button,'Enable','on');
        set(connect_wind,'String','Connecting...');
        drawnow;
        
        if (exist_t)
            fclose(t);
            delete(t); 
            clear t; 
            exist_t = false;
        end
        %Creates a TCPIP object = t, associated with remote host = 80.
        checkbox1_status = get(checkbox1,'Value');
        checkbox2_status = get(checkbox2,'Value');
        
        if (checkbox1_status && ~checkbox2_status)
            t = tcpip(get(ip1_wind,'String'), 80);
            exist_t = true;
        elseif (checkbox2_status && ~checkbox1_status)
            t = tcpip(get(ip2_wind,'String'), 80);
            exist_t = true;
        else
            errordlg('Cannot define IP address','Connection error');
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Connection error.']}));
            fprintf(fid, '%s :: Connection error.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
            set(connect_wind,'String','Disconnected.');
        end
        
        % Set size of receiving buffer, if needed. 
        set(t, 'InputBufferSize', 30000);
        % Time for scanning the ethernet port 100 mks
        set(t, 'timeout', 0.1);
        % Open connection to the server.
        fopen(t);      
        %wait for connection
        while ~isvalid(t)
        end
        if(isvalid(t))
            connection = true;
            set(connect_wind,'String','Connected.');
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Connected']}));
            fprintf(fid, '%s :: Connected.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
        else
            connection = false;
            errordlg('Cannot connect','Connection error');
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Connection error.']}));
            fprintf(fid, '%s :: Connection error.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
            set(connect_wind,'String','Disconnected.');
        end
    end
%% DISCONNECT
    function disconnectbutton_Callback(~,~,~)
        set(checkbox1,'Enable','on');
        set(checkbox2,'Enable','on');
        set(connect_button,'Enable','on');
        set(disconnect_button,'Enable','off');        
        drawnow;
        
        fclose(t);
        delete(t); 
        clear t;
        exist_t = false;
        connection = false;
        set(connect_wind,'String','Disconnected.');
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Disconnected.']}));
        fprintf(fid, '%s :: Disconnected.\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));        
    end

%% ENABLE BUTTON (MOTOR I)
    function enable1button_Callback(~,~,~)
        if(connection)
            fprintf(t, '?eall');
            
            set(enable1_button,'Enable','off');
            set(enable2_button,'Enable','off');

            set(disable1_button,'Enable','on');
            set(disable2_button,'Enable','on');
            set(start1_button,'Enable','on');
            set(start2_button,'Enable','on');
            set(stop1_button,'Enable','on');
            set(stop2_button,'Enable','on');

            if get(checkbox2,'Value')
                set(enable3_button,'Enable','off');
                
                set(disable3_button,'Enable','on');                    
                set(start3_button,'Enable','on');                    
                set(stop3_button,'Enable','on');                    
            end          
            
            enable1 = true;
            enable2 = true;
            enable3 = true;
            
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Enable Motors.']}));
            fprintf(fid, '%s :: Enable Motors.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% DISABLE BUTTON (MOTOR I)
    function disable1button_Callback(~,~,~)
        if(connection)            
            fprintf(t, '?deall');
            
            set(enable1_button,'Enable','on');
            set(enable2_button,'Enable','on');

            set(disable1_button,'Enable','off');
            set(disable2_button,'Enable','off');
            set(start1_button,'Enable','off');
            set(start2_button,'Enable','off');
            set(stop1_button,'Enable','off');
            set(stop2_button,'Enable','off');

            if get(checkbox2,'Value')
                set(enable3_button,'Enable','on');
                
                set(disable3_button,'Enable','off');                    
                set(start3_button,'Enable','off');                    
                set(stop3_button,'Enable','off');                    
            end          
            
            enable1 = false;
            enable2 = false;
            enable3 = false;
            
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Disable Motors.']}));
            fprintf(fid, '%s :: Disable Motors.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% START BUTTON (MOTOR I)
    function start1button_Callback(~,~,~)
        if(connection && enable1 && target1 && ~start1 && ~start2 && ~start3)
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Motor I has started to move.']}));
            fprintf(fid, '%s :: Motor I has started to move.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
            
            start1 = true;
            speed = str2double(get(speed1_wind,'String'))*mm2steps;
            accel = str2double(get(acc1_wind,'String'))*mm2steps;
            
            if speed < 1.0
                speed = 1;
            elseif speed > 10.0*mm2steps
                speed = 10.0*mm2steps;
            end
            if accel < 1.0
                accel = 1;
            elseif accel > speed
                accel = speed;
            end
            
            fprintf(t,['?m1sp' num2str(int64(speed))]);
            fprintf(t,['?m1ac' num2str(int64(accel))]);
            
            set(speed1_wind,'String',speed*steps2mm);
            set(acc1_wind,'String',accel*steps2mm);
            
            fprintf(t,['?m1move' num2str(targetpos1)]);
            
            x0 = str2double(get(curpos1_wind,'String'))*mm2steps;
            distanceToGo1 = abs(targetpos1 - x0);            
            while abs(distanceToGo1) > 0
                pause(0.1)
                drawnow;
                if ~start1
                    break;
                end
                fprintf(t,'?b');
                pause(0.5);
                inputchar = '';
                while (get(t, 'BytesAvailable') > 0)
                    inputchar = fscanf(t);
                end
                distanceToGo1 = str2double(inputchar);
                x = x0 + ((targetpos1 - x0)./abs(targetpos1 ...
                    - x0)).*(abs(targetpos1 - x0) - abs(distanceToGo1));                
                
                set(curpos1_wind,'String',num2str(x*steps2mm));
                
                x1 = str2double(get(curpos1_wind,'String'));
                x2 = str2double(get(curpos2_wind,'String'));
                set(gap_wind_1,'String',num2str(abs(x2-x1)));
                
                
                set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                    {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                    ' :: PosMotI = ' num2str(x*steps2mm) ' mm.']}));
                fprintf(fid, '%s :: PosMotI = %12.12f mm.\n',...
                    datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),x*steps2mm);
                
                if abs(distanceToGo1) == 0
                    start1 = false;                
                end
                
                % Check gap limitation
                if gat_switch_status                
                    if abs(x2-x1) < gat_limit_value
                        set(gap_wind_2,'String',num2str(gat_limit_value));
                        gap_function();
                        break;
                    end
                end
            end
        else
            errordlg('ERROR, wrong Connection or Enabling or Target position!!!','Error');
        end
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Motor I has been stopped.']}));
        fprintf(fid, '%s :: Motor I has been stopped.\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
    end
%% STOP BUTTON (MOTOR I)
    function stop1button_Callback(~,~,~)
        start1 = false;        
        fprintf(t,'?m1stop');       
        drawnow; 
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Motor I has been stopped.']}));
        fprintf(fid, '%s :: Motor I has been stopped.\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
    end
%% SET CURRENT POSITION BUTTON (MOTOR I)
    function setcurpos1button_Callback(~,~,~)
        if(connection)
            clear choice;
            choice = questdlg('In which way?','Attention!','Manually', ...
                'From LOG file','Cancel','Cancel');
            switch choice
                case 'Manually'
                    clear curpos1;
                    curpos1 = str2double(get(curpos1_wind,'String'))*mm2steps;
                    fprintf(t, ['?m1cp' num2str(int64(curpos1))]);
                    
                    set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                        {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                        ' :: Added current position for Motor I is '...
                        get(curpos1_wind,'String') ' mm.']}));
                    fprintf(fid,...
                        '%s :: Added current position for Motor I is %s mm.\n',...
                        datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
                        get(curpos1_wind,'String'));  
                    
                    x1 = str2double(get(curpos1_wind,'String'));
                    x2 = str2double(get(curpos2_wind,'String'));
                    set(gap_wind_1,'String',num2str(abs(x2-x1)));
                case 'From LOG file'
                    clear fileID filename pathname;
                    [filename, pathname] = uigetfile({'*.txt';'*.dat';'*.*'},'File Selector','logfile.txt');
                    fileID = fopen([pathname filename],'r');        
                    XYc1 = textscan(fileID,'%s');
                    fclose(fileID);
                    XYc2 = cellstr(XYc1{1});
                    clear XYc1;
                    SizeOfXYc2 = size(XYc2,1);
                    ii = 1;
                    h = waitbar(0,'Please wait...');
                    while ii <= SizeOfXYc2
                        if strcmp(XYc2(ii),'PosMotI') && strcmp(XYc2(ii+1),'=')
                            set(curpos1_wind,'String',char(XYc2(ii+2)));
                            ii = ii + 2;
                        end
                        waitbar(ii / SizeOfXYc2)
                        ii = ii + 1;
                    end
                    curpos1 = str2double(get(curpos1_wind,'String'))*mm2steps;
                    fprintf(t, ['?m1cpm' num2str(int64(curpos1))]);
                    
                    set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                        {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                        ' :: Added current position for Motor I is '...
                        get(curpos1_wind,'String') ' mm.']}));
                    fprintf(fid,...
                        '%s :: Added current position for Motor I is %s mm.\n',...
                        datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
                        get(curpos1_wind,'String')); 
                    
                    x1 = str2double(get(curpos1_wind,'String'));
                    x2 = str2double(get(curpos2_wind,'String'));
                    set(gap_wind_1,'String',num2str(abs(x2-x1)));
                    
                    close(h);
                    msgbox('Done!');
                case 'Cancel'
            end
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% SET TARGET POSITION BUTTON (MOTOR I)
    function settargpos1button_Callback(~,~,~)
        if(connection)
            clear choice;
            choice = questdlg('Are you sure?','Attention!','Yes', ...
                'No','No');
            switch choice
                case 'Yes'
                    clear targetpos1;
                    targetpos1 = str2double(get(targpos1_wind,'String'));
                    targetpos1 = targetpos1*mm2steps;
                    target1 = true;
                    set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                        {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                        ' :: Added target position for Motor I is '...
                        get(targpos1_wind,'String') ' mm.']}));
                    fprintf(fid,...
                        '%s :: Added target position for Motor I is %s mm.\n',...
                        datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
                        get(targpos1_wind,'String'));
                case 'No'
            end            
        else
            errordlg('Connect, please!','Connection error');
        end
    end

%% ENABLE BUTTON (MOTOR II)
    function enable2button_Callback(~,~,~)
        if(connection)
            fprintf(t, '?eall');
            
            set(enable1_button,'Enable','off');
            set(enable2_button,'Enable','off');

            set(disable1_button,'Enable','on');
            set(disable2_button,'Enable','on');
            set(start1_button,'Enable','on');
            set(start2_button,'Enable','on');
            set(stop1_button,'Enable','on');
            set(stop2_button,'Enable','on');

            if get(checkbox2,'Value')
                set(enable3_button,'Enable','off');
                
                set(disable3_button,'Enable','on');                    
                set(start3_button,'Enable','on');                    
                set(stop3_button,'Enable','on');                    
            end          
            
            enable1 = true;
            enable2 = true;
            enable3 = true;
            
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Enable Motors.']}));
            fprintf(fid, '%s :: Enable Motors.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% DISABLE BUTTON (MOTOR II)
    function disable2button_Callback(~,~,~)
        if(connection)
            fprintf(t, '?deall');
            
            set(enable1_button,'Enable','on');
            set(enable2_button,'Enable','on');

            set(disable1_button,'Enable','off');
            set(disable2_button,'Enable','off');
            set(start1_button,'Enable','off');
            set(start2_button,'Enable','off');
            set(stop1_button,'Enable','off');
            set(stop2_button,'Enable','off');

            if get(checkbox2,'Value')
                set(enable3_button,'Enable','on');
                
                set(disable3_button,'Enable','off');                    
                set(start3_button,'Enable','off');                    
                set(stop3_button,'Enable','off');                    
            end          
            
            enable1 = false;
            enable2 = false;
            enable3 = false;
            
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Disable Motors.']}));
            fprintf(fid, '%s :: Disable Motors.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% START BUTTON (MOTOR II)
    function start2button_Callback(~,~,~)
        if(connection && enable2 && target2 && ~start1 && ~start2 && ~start3)
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Motor II has started to move.']}));
            fprintf(fid, '%s :: Motor II has started to move.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
            
            start2 = true;
            speed = str2double(get(speed2_wind,'String'))*mm2steps;
            accel = str2double(get(acc2_wind,'String'))*mm2steps;
            
            if speed < 1.0
                speed = 1;
            elseif speed > 10.0*mm2steps
                speed = 10.0*mm2steps;
            end
            if accel < 1.0
                accel = 1;
            elseif accel > speed
                accel = speed;
            end
            
            fprintf(t,['?m2sp' num2str(int64(speed))]);
            fprintf(t,['?m2ac' num2str(int64(accel))]);
            
            set(speed2_wind,'String',speed*steps2mm);
            set(acc2_wind,'String',accel*steps2mm);
            
            fprintf(t,['?m2move' num2str(targetpos2)]);
            
            x0 = str2double(get(curpos2_wind,'String'))*mm2steps;
            distanceToGo2 = abs(targetpos2 - x0);            
            while abs(distanceToGo2) > 0
                pause(0.1)
                drawnow;
                if ~start2
                    break;
                end
                fprintf(t,'?u');
                pause(0.5);
                inputchar = '';
                while (get(t, 'BytesAvailable') > 0)
                    inputchar = fscanf(t);
                end
                distanceToGo2 = str2double(inputchar);
                x = x0 + ((targetpos2 - x0)./abs(targetpos2 ...
                    - x0)).*(abs(targetpos2 - x0) - abs(distanceToGo2));                
                                
                set(curpos2_wind,'String',num2str(x*steps2mm));
                
                x1 = str2double(get(curpos1_wind,'String'));
                x2 = str2double(get(curpos2_wind,'String'));
                set(gap_wind_1,'String',num2str(abs(x2-x1)));
                    
                set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                    {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                    ' :: PosMotII = ' num2str(x*steps2mm) ' mm.']}));
                fprintf(fid, '%s :: PosMotII = %12.12f mm.\n',...
                    datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),x*steps2mm);
                
                if abs(distanceToGo2) == 0
                    start2 = false;
                end
                
                % Check gap limitation
                if gat_switch_status                
                    if abs(x2-x1) < gat_limit_value
                        set(gap_wind_2,'String',num2str(gat_limit_value));
                        gap_function();
                        break;
                    end
                end
            end
        else
            errordlg('ERROR, wrong Connection or Enabling or Target position!!!','Error');
        end
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Motor II has been stopped.']}));
        fprintf(fid, '%s :: Motor II has been stopped.\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
    end
%% STOP BUTTON (MOTOR II)
    function stop2button_Callback(~,~,~)
        start2 = false;
        fprintf(t,'?m2stop');
        drawnow;
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Motor II has been stopped.']}));
        fprintf(fid, '%s :: Motor II has been stopped.\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
    end
%% SET CURRENT POSITION BUTTON (MOTOR II)
    function setcurpos2button_Callback(~,~,~)
        if(connection)
            clear choice;
            choice = questdlg('In which way?','Attention!','Manually', ...
                'From LOG file','Cancel','Cancel');
            switch choice
                case 'Manually'
                    clear curpos2;
                    curpos2 = str2double(get(curpos2_wind,'String'))*mm2steps;
                    fprintf(t, ['?m2cpm' num2str(int64(curpos2))]);
                    
                    set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                        {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                        ' :: Added current position for Motor II is '...
                        get(curpos2_wind,'String') ' mm.']}));
                    fprintf(fid,...
                        '%s :: Added current position for Motor II is %s mm.\n',...
                        datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
                        get(curpos2_wind,'String'));
                    
                    x1 = str2double(get(curpos1_wind,'String'));
                    x2 = str2double(get(curpos2_wind,'String'));
                    set(gap_wind_1,'String',num2str(abs(x2-x1)));
                case 'From LOG file'
                    clear fileID filename pathname;
                    [filename, pathname] = uigetfile({'*.txt';'*.dat';'*.*'},'File Selector','logfile.txt');
                    fileID = fopen([pathname filename],'r');        
                    XYc1 = textscan(fileID,'%s');
                    fclose(fileID);
                    XYc2 = cellstr(XYc1{1});
                    clear XYc1;
                    SizeOfXYc2 = size(XYc2,1);
                    ii = 1;
                    h = waitbar(0,'Please wait...');
                    while ii <= SizeOfXYc2
                        if strcmp(XYc2(ii),'PosMotII') && strcmp(XYc2(ii+1),'=')
                            set(curpos2_wind,'String',char(XYc2(ii+2)));
                            ii = ii + 2;
                        end
                        waitbar(ii / SizeOfXYc2)
                        ii = ii + 1;
                    end                    
                    curpos2 = str2double(get(curpos2_wind,'String'))*mm2steps;
                    fprintf(t, ['?m2cpm' num2str(int64(curpos2))]);
                    
                    set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                        {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                        ' :: Added current position for Motor II is '...
                        get(curpos2_wind,'String') ' mm.']}));
                     
                    fprintf(fid,...
                        '%s :: Added current position for Motor II is %s mm.\n',...
                        datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
                        get(curpos2_wind,'String'));
                    
                    x1 = str2double(get(curpos1_wind,'String'));
                    x2 = str2double(get(curpos2_wind,'String'));
                    set(gap_wind_1,'String',num2str(abs(x2-x1)));
                    
                    close(h);
                    msgbox('Done!');
                case 'Cancel'
            end
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% SET TARGET POSITION BUTTON (MOTOR II)
    function settargpos2button_Callback(~,~,~)
        if(connection)
            clear choice;
            choice = questdlg('Are you sure?','Attention!','Yes', ...
                'No','No');
            switch choice
                case 'Yes'
                    clear targetpos2;
                    targetpos2 = str2double(get(targpos2_wind,'String'));
                    targetpos2 = targetpos2*mm2steps;
                    target2 = true;
                    set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                        {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                        ' :: Added target position for Motor II is '...
                        get(targpos2_wind,'String') ' mm.']}));
                    fprintf(fid,...
                        '%s :: Added target position for Motor II is %s mm.\n',...
                        datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
                        get(targpos2_wind,'String'));
                case 'No'
            end            
        else
            errordlg('Connect, please!','Connection error');
        end
    end

%% ENABLE BUTTON (MOTOR III)
    function enable3button_Callback(~,~,~)
        if(connection)
            fprintf(t, '?eall');
            
            set(enable1_button,'Enable','off');
            set(enable2_button,'Enable','off');

            set(disable1_button,'Enable','on');
            set(disable2_button,'Enable','on');
            set(start1_button,'Enable','on');
            set(start2_button,'Enable','on');
            set(stop1_button,'Enable','on');
            set(stop2_button,'Enable','on');

            if get(checkbox2,'Value')
                set(enable3_button,'Enable','off');
                
                set(disable3_button,'Enable','on');                    
                set(start3_button,'Enable','on');                    
                set(stop3_button,'Enable','on');                    
            end          
            
            enable1 = true;
            enable2 = true;
            enable3 = true;
            
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Enable Motors.']}));
            fprintf(fid, '%s :: Enable Motors.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% DISABLE BUTTON (MOTOR III)
    function disable3button_Callback(~,~,~)
        if(connection)
            fprintf(t, '?deall');
            
            set(enable1_button,'Enable','on');
            set(enable2_button,'Enable','on');

            set(disable1_button,'Enable','off');
            set(disable2_button,'Enable','off');
            set(start1_button,'Enable','off');
            set(start2_button,'Enable','off');
            set(stop1_button,'Enable','off');
            set(stop2_button,'Enable','off');

            if get(checkbox2,'Value')
                set(enable3_button,'Enable','on');
                
                set(disable3_button,'Enable','off');                    
                set(start3_button,'Enable','off');                    
                set(stop3_button,'Enable','off');                    
            end          
            
            enable1 = false;
            enable2 = false;
            enable3 = false;
            
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Disable Motors.']}));
            fprintf(fid, '%s :: Disable Motors.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% START BUTTON (MOTOR III)
    function start3button_Callback(~,~,~)
        if(connection && enable3 && target3 && ~start1 && ~start2 && ~start3 && scanmode3 == 0)
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Motor III has started to move.']}));
            fprintf(fid, '%s :: Motor III has started to move.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
            
            start3 = true;
            speed = str2double(get(speed3_wind,'String'))*mm2steps;
            accel = str2double(get(acc3_wind,'String'))*mm2steps;
            
            if speed < 1.0
                speed = 1;
            elseif speed > 10.0*mm2steps
                speed = 10.0*mm2steps;
            end
            if accel < 1.0
                accel = 1;
            elseif accel > speed
                accel = speed;
            end
            
            fprintf(t,['?m3sp' num2str(int64(speed))]);
            fprintf(t,['?m3ac' num2str(int64(accel))]);
            
            set(speed3_wind,'String',speed*steps2mm);
            set(acc3_wind,'String',accel*steps2mm);
            
            fprintf(t,['?m3move' num2str(int64(targetpos3))]);
            
            x0 = str2double(get(curpos3_wind,'String'))*mm2steps;
            distanceToGo3 = abs(targetpos3 - x0);      
           
            while abs(distanceToGo3) > 0
                pause(0.1)
                drawnow;
                if ~start3
                    break;
                end
                
                fprintf(t,'?q');
                pause(0.5);
                inputchar = '';
                while (get(t, 'BytesAvailable') > 0)
                    inputchar = fscanf(t);
                end
                
                distanceToGo3 = str2double(inputchar);                   
                x = x0 + ((targetpos3 - x0)./abs(targetpos3 ...
                    - x0))*(abs(targetpos3 - x0) - abs(distanceToGo3)); 
                
                set(curpos3_wind,'String',num2str(x*steps2mm));

                set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                    {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                    ' :: PosMotIII = ' num2str(x*steps2mm) ' mm.']}));
                fprintf(fid, '%s :: PosMotIII = %12.12f mm.\n',...
                    datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),x*steps2mm);
                
                if abs(distanceToGo3) == 0
                    start3 = false;                
                end
            end
        elseif(connection && enable3 && target3 && ~start1 && ~start2 && ~start3 && scanmode3 == 1)
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Scanning mode was started.']}));
            fprintf(fid, '%s :: Scanning mode was started.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
            
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Waiting time is: ' get(pause3_wind,'String')]}));
            fprintf(fid, '%s :: Waiting time is: %s\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'), get(pause3_wind,'String'));
            
            start3 = true;
            speed = str2double(get(speed3_wind,'String'))*mm2steps;
            accel = str2double(get(acc3_wind,'String'))*mm2steps;
            
            if speed < 1.0
                speed = 1;
            elseif speed > 10.0*mm2steps
                speed = 10.0*mm2steps;
            end
            if accel < 1.0
                accel = 1;
            elseif accel > speed
                accel = speed;
            end
            
            fprintf(t,['?msp' num2str(int64(speed))]);
            fprintf(t,['?mac' num2str(int64(accel))]);
            
            set(speed3_wind,'String',speed*steps2mm);
            set(acc3_wind,'String',accel*steps2mm);
            
            x0 = str2double(get(curpos3_wind,'String'))*mm2steps;
            pauseTime = abs(str2double(get(pause3_wind,'String')));
            trajectory = x0 + linspace(...
                str2double(get(lowlimit3_wind,'String')),...
                str2double(get(highlimit3_wind,'String')),...
                str2double(get(npoints3_wind,'String'))).*mm2steps;
            ini_num = 1;
            
            while ini_num <= str2double(get(npoints3_wind,'String'))
                if ~start3
                    break;
                end
                distanceToGo3 = abs(trajectory(ini_num) - x0);

                set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                    {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                    ' :: Motor III has started to move.']}));
                fprintf(fid, '%s :: Motor III has started to move.\n',...
                    datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
                
                fprintf(t,['?m3move' num2str(int64(trajectory(ini_num)))]);
                pause(0.5);                
                
                while abs(distanceToGo3) > 0
                    pause(0.1)
                    drawnow;
                    if ~start3                       
                        break;
                    end                    
                
                    fprintf(t,'?q');
                    pause(0.1);
                    while (get(t, 'BytesAvailable') > 0)
                        inputchar = fscanf(t);
                    end
                    distanceToGo3 = str2double(inputchar);
                    x = x0+((trajectory(ini_num) - x0)/abs(trajectory(ini_num) ...
                        - x0))*(abs(trajectory(ini_num) - x0) - abs(distanceToGo3));
                                       
                    set(curpos3_wind,'String',num2str(x*steps2mm));
                    set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                        {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                        ' :: PosMotIII = ' num2str(x*steps2mm) ' mm.']}));
                    fprintf(fid, '%s :: PosMotIII = %12.12f mm.\n',...
                        datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),x*steps2mm);
                    
                end
                set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                    {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                    ' :: Motor III has been stopped.']}));
                fprintf(fid, '%s :: Motor III has been stopped.\n',...
                    datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
                if start3
                    x0 = trajectory(ini_num);
                    ini_num = ini_num + 1;

                    if ~start3
                        break;
                    end
                    hh = waitbar(0,['Please wait ' num2str(pauseTime) ' seconds at this point.']);
                    tic;
                    tocv = toc;
                    while tocv <= pauseTime
                        waitbar(tocv/pauseTime)
                        tocv = toc;
                        if ~start3
                            break;
                        end
                    end
                    close(hh)
                    clear hh;
                    if ~start3
                        break;
                    end
                end                
            end
            start3 = false;
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: Scanning mode was stopped.']}));
            fprintf(fid, '%s :: Scanning mode was stopped.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
        else
            errordlg('ERROR, wrong Connection or Enabling or Target position!!!','Error');
        end
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Motor III has been stopped.']}));
        fprintf(fid, '%s :: Motor III has been stopped.\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
    end
%% STOP BUTTON (MOTOR III)
    function stop3button_Callback(~,~,~)
        start3 = false;        
        fprintf(t,'?m3stop');
        drawnow; 
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Motor III has been stopped.']}));
        fprintf(fid, '%s :: Motor III has been stopped.\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
    end
%% SET CURRENT POSITION BUTTON (MOTOR III)
    function setcurpos3button_Callback(~,~,~)
        if(connection)
            clear choice;
            choice = questdlg('In which way?','Attention!','Manually', ...
                'From LOG file','Cancel','Cancel');
            switch choice
                case 'Manually'
                    clear curpos3;
                    curpos3 = str2double(get(curpos3_wind,'String'))*mm2steps;
                    fprintf(t, ['?m3cp' num2str(int64(curpos3))]);
                    
                    set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                        {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                        ' :: Added current position for Motor III is '...
                        get(curpos3_wind,'String') ' mm.']}));
                    fprintf(fid,...
                        '%s :: Added current position for Motor III is %s mm.\n',...
                        datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
                        get(curpos3_wind,'String'));                                                     
                case 'From LOG file'
                    clear fileID filename pathname;
                    [filename, pathname] = uigetfile({'*.txt';'*.dat';'*.*'},...
                        'File Selector','logfile.txt');
                    fileID = fopen([pathname filename],'r');        
                    XYc1 = textscan(fileID,'%s');
                    fclose(fileID);
                    XYc2 = cellstr(XYc1{1});
                    clear XYc1;
                    SizeOfXYc2 = size(XYc2,1);
                    ii = 1;
                    h = waitbar(0,'Please wait...');
                    while ii <= SizeOfXYc2
                        if strcmp(XYc2(ii),'PosMotIII') && strcmp(XYc2(ii+1),'=')
                            set(curpos_wind,'String',char(XYc2(ii+2)));
                            ii = ii + 2;
                        end
                        waitbar(ii / SizeOfXYc2)
                        ii = ii + 1;
                    end
                    curpos3 = str2double(get(curpos3_wind,'String'))*mm2steps;
                    fprintf(t, ['?m3cp' num2str(int64(curpos3))]);
                    
                    set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                        {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                        ' :: Added current position for Motor III is '...
                        get(curpos3_wind,'String') ' mm.']}));
                    fprintf(fid,...
                        '%s :: Added current position for Motor III is %s mm.\n',...
                        datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
                        get(curpos3_wind,'String'));                                     
                    close(h);
                    msgbox('Done!');
                case 'Cancel'
            end
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% SET TARGET POSITION BUTTON (MOTOR III)
    function settargpos3button_Callback(~,~,~)
        if(connection)
            clear choice;
            choice = questdlg('Are you sure?','Attention!','Yes', ...
                'No','No');
            switch choice
                case 'Yes'
                    clear targetpos3;
                    targetpos3 = str2double(get(targpos3_wind,'String'));
                    targetpos3 = targetpos3*mm2steps;
                    target3 = true;
                    set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                        {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                        ' :: Added target position for Motor III is '...
                        get(targpos3_wind,'String') ' mm.']}));
                    fprintf(fid,...
                        '%s :: Added target position for Motor III is %s mm.\n',...
                        datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
                        get(targpos3_wind,'String'));
                case 'No'
            end            
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% CHECKBOX (MOTOR III)
    function checkbox3_Callback(~,~,~)
        scanmode3 = get(checkbox3,'Value');
        if scanmode3
            set(settargpos3_button,'Enable','off');
            target3 = true;
        else
            set(settargpos3_button,'Enable','on');
            target3 = false;
        end
    end

%% STOP BUTTON
    function stopbutton_Callback(~,~,~)
        start1 = false;
        start2 = false;
        start3 = false;
        fprintf(t,'?m1stop');
        pause(0.01);
        fprintf(t,'?m2stop');
        pause(0.01);
        fprintf(t,'?m3stop');
        drawnow;
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Motor I & Motor II & Motor III have been stopped.']}));
        fprintf(fid, '%s :: Motor I & Motor II & Motor III have been stopped.\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
    end
%% HELP BUTTON
    function helpbutton_Callback(~,~,~) 
        helpfig = figure('Visible','off','Name',...
            'Help window','Position',[450,200,400,300]);
        set(helpfig,'NumberTitle','off');
        set(helpfig, 'MenuBar', 'none');
        set(helpfig, 'ToolBar', 'none');
        help_wind = uicontrol('Parent',helpfig,'Style','list','FontSize',10,...
            'Units','normalized','BackgroundColor','w','ForegroundColor','k',...
            'Position',[0.01 0.01 0.98 0.98]);
        movegui(helpfig,'center');
        set([helpfig,help_wind],'Units','normalized');
        set(helpfig,'Visible','on');
        
        set(help_wind, 'String', cat(1, get(help_wind, 'String'),{'For any help, please, contact:'}));
        set(help_wind, 'String', cat(1, get(help_wind, 'String'),{''}));
        set(help_wind, 'String', cat(1, get(help_wind, 'String'),{'Andrii Natochii (andrii.natochii@cern.ch)'}));
        set(help_wind, 'String', cat(1, get(help_wind, 'String'),{'Marco Garattini (marco.garattini@cern.ch)'}));
        set(help_wind, 'String', cat(1, get(help_wind, 'String'),{'Yury Gavrikov (yury.gavrikov@cern.ch)'}));
    end
%% GET STATUS BUTTON
    function statusbutton_Callback(~,~,~)
        if(connection)
            h = waitbar(0,'Please wait...');
            stps = 1000;
            for st = 1:stps
                waitbar(st / stps)
            end
            close(h)
            
            fprintf(t,'?eallst');
            pause(0.5);
            while (get(t, 'BytesAvailable') > 0)
                inputchar = fscanf(t);
            end
            eall_status = str2double(inputchar);
            
            if eall_status
                set(enable1_button,'Enable','off');
                set(enable2_button,'Enable','off');
                
                set(disable1_button,'Enable','on');
                set(disable2_button,'Enable','on');
                set(start1_button,'Enable','on');
                set(start2_button,'Enable','on');
                set(stop1_button,'Enable','on');
                set(stop2_button,'Enable','on');
                
                if get(checkbox2,'Value')
                    set(enable3_button,'Enable','off');
                    
                    set(disable3_button,'Enable','on');                    
                    set(start3_button,'Enable','on');                    
                    set(stop3_button,'Enable','on');                    
                end
            else
                set(enable1_button,'Enable','on');
                set(enable2_button,'Enable','on');
                
                set(disable1_button,'Enable','off');
                set(disable2_button,'Enable','off');
                set(start1_button,'Enable','off');
                set(start2_button,'Enable','off');
                set(stop1_button,'Enable','off');
                set(stop2_button,'Enable','off');
                
                if get(checkbox2,'Value')
                    set(enable3_button,'Enable','on');
                    
                    set(disable3_button,'Enable','off');                    
                    set(start3_button,'Enable','off');                    
                    set(stop3_button,'Enable','off');                    
                end
            end
            
            
            fprintf(t,'?gcp1');
            pause(0.5);
            while (get(t, 'BytesAvailable') > 0)
                inputchar = fscanf(t);
            end
            x = str2double(inputchar);
            set(curpos1_wind,'String',num2str(x*steps2mm));
            
            fprintf(t,'?gcp2');
            pause(0.5);
            while (get(t, 'BytesAvailable') > 0)
                inputchar = fscanf(t);
            end
            x = str2double(inputchar);
            set(curpos2_wind,'String',num2str(x*steps2mm));
            
            if get(checkbox2,'Value')
                fprintf(t,'?gcp3');
                pause(0.5);
                while (get(t, 'BytesAvailable') > 0)
                    inputchar = fscanf(t);
                end
                x = str2double(inputchar);
                set(curpos3_wind,'String',num2str(x*steps2mm));
            end
            
            fprintf(t,'?mst');
            pause(0.5);
            while (get(t, 'BytesAvailable') > 0)
                inputchar = fscanf(t);
            end
                
            set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                ' :: ' inputchar]}));
            fprintf(fid, '%s :: %s.\n',...
                datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),inputchar);
            drawnow;
        else
            errordlg('Connect, please!','Connection error');
        end
    end
%% SET NEW BEAM BUTTON
    function setbeambutton_Callback(~,~,~)
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Beam position is: BPN = ' get(beam_wind,'String')]}));
        fprintf(fid, '%s :: Beam position is: BPN = %s\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
            get(beam_wind,'String'));
        drawnow;
    end
%% GET PREVIOUS BEAM BUTTON
    function getbeambutton_Callback(~,~,~)        
        clear fileID filename pathname;
        [filename, pathname] = uigetfile({'*.txt';'*.dat';'*.*'},'File Selector','logfile.txt');
        fileID = fopen([pathname filename],'r');        
        XYc1 = textscan(fileID,'%s');
        fclose(fileID);
        XYc2 = cellstr(XYc1{1});
        clear XYc1;
        SizeOfXYc2 = size(XYc2,1);
        ii = 1;
        h = waitbar(0,'Please wait...');
        while ii <= SizeOfXYc2
            if strcmp(XYc2(ii),'BPN') && strcmp(XYc2(ii+1),'=')
                set(beam_wind,'String',char(XYc2(ii+2)));
                ii = ii + 2;
            end
            waitbar(ii / SizeOfXYc2)
            ii = ii + 1;
        end
        close(h);
        msgbox('Done!');
        
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Beam position is: BPN = ' get(beam_wind,'String')]}));
        fprintf(fid, '%s :: Beam position is: BPN = %s\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
            get(beam_wind,'String'));
        drawnow;
    end
%% RADIO BUTTONS
    function radiobuttonsselection(~,~)
        switch get(get(radio_button_group,'SelectedObject'),'Tag')
            case 'ON'  
                gat_switch_status = true;
                gat_limit_value = str2double(get(gap_wind_1,'String'));
                set(gap_wind_2,'String',num2str(gat_limit_value));
                set(gap_wind_2,'Enable','on');
                set(set_gap_button,'Enable','on');
                set(get_gap_button,'Enable','on');                
                
                set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                    {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                    ' :: Gap Limitation is ON.']}));
                fprintf(fid, '%s :: Gap Limitation is ON.\n',...
                    datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
                
                set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                    {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                    ' :: Gap value is: GPV = ' num2str(gat_limit_value)]}));
                fprintf(fid, '%s :: Gap value is: GPV = %s\n',...
                    datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
                    num2str(gat_limit_value));
            case 'OFF'
                gat_switch_status = false;
                set(gap_wind_2,'String',num2str(0));
                set(gap_wind_2,'Enable','off');
                set(set_gap_button,'Enable','off');
                set(get_gap_button,'Enable','off');
                
                set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
                    {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
                    ' :: Gap Limitation is OFF.']}));
                fprintf(fid, '%s :: Gap Limitation is OFF.\n',...
                    datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
        end
        drawnow;
    end
%% GAP FUNCTION
    function gap_function()
        start1 = false;        
        start2 = false;   
        drawnow;
        fprintf(t,'?m1stop');
        pause(0.01);
        fprintf(t,'?m2stop');
        drawnow;
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Motor I & Motor II have been stopped.']}));
        fprintf(fid, '%s :: Motor I & Motor II have been stopped.\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'));
        msgbox(['The gap between motors is less than '...
            num2str(gat_limit_value) ' mm !!!']); 
    end
%% SET NEW GAP BUTTON
    function setgapbutton_Callback(~,~,~)
        gat_limit_value = str2double(get(gap_wind_2,'String'));
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Gap value is: GPV = ' num2str(gat_limit_value)]}));
        fprintf(fid, '%s :: Gap value is: GPV = %s\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
            num2str(gat_limit_value));
        drawnow;
    end
%% GET PREVIOUS GAP BUTTON
    function getgapbutton_Callback(~,~,~)        
        clear fileID filename pathname;
        [filename, pathname] = uigetfile({'*.txt';'*.dat';'*.*'},'File Selector','logfile.txt');
        fileID = fopen([pathname filename],'r');        
        XYc1 = textscan(fileID,'%s');
        fclose(fileID);
        XYc2 = cellstr(XYc1{1});
        clear XYc1;
        SizeOfXYc2 = size(XYc2,1);
        ii = 1;
        h = waitbar(0,'Please wait...');
        while ii <= SizeOfXYc2
            if strcmp(XYc2(ii),'GPV') && strcmp(XYc2(ii+1),'=')
                set(gap_wind_2,'String',char(XYc2(ii+2)));
                ii = ii + 2;
            end
            waitbar(ii / SizeOfXYc2)
            ii = ii + 1;
        end
        close(h);
        msgbox('Done!');
        
        gat_limit_value = str2double(get(gap_wind_2,'String'));
        set(log_wind, 'String', cat(1, get(log_wind, 'String'),...
            {[datestr(now,'mmmm dd, yyyy HH:MM:SS AM')...
            ' :: Gap value is: GPV = ' num2str(gat_limit_value)]}));
        fprintf(fid, '%s :: Gap value is: GPV = %s\n',...
            datestr(now,'mmmm dd, yyyy HH:MM:SS AM'),...
            num2str(gat_limit_value));
        drawnow;
    end
end
%%
