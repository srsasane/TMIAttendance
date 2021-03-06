function varargout = TMIAttend(varargin)
% TMIATTEND MATLAB code for TMIAttend.fig
%      TMIATTEND, by itself, creates a new TMIATTEND or raises the existing
%      singleton*.
%
%      H = TMIATTEND returns the handle to a new TMIATTEND or the handle to
%      the existing singleton*.
%
%      TMIATTEND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TMIATTEND.M with the given input arguments.
%
%      TMIATTEND('Property','Value',...) creates a new TMIATTEND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TMIAttend_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TMIAttend_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TMIAttend

% Last Modified by GUIDE v2.5 14-Sep-2017 09:19:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TMIAttend_OpeningFcn, ...
    'gui_OutputFcn',  @TMIAttend_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TMIAttend is made visible.
function TMIAttend_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TMIAttend (see VARARGIN)

% Choose default command line output for TMIAttend
handles.output = hObject;
handles.ExcelFile='Z:\Sudhir-s\TMIAttendance\master.xlsx';

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes TMIAttend wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TMIAttend_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in LoadFile.
function LoadFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%=====||======
% Load excel file containing all list of ME / NS students
%[FileName,PathName]=uigetfile('*.xlsx', 'Select Cadet list file');
%handles.ExcelFile=fullfile(PathName,FileName);

[a, mStudentME1,cRawME1]=xlsread(handles.ExcelFile,'ME1');
[a, mStudentME2,cRawME2]=xlsread(handles.ExcelFile,'ME2');
[a, mStudentNS1,cRawNS1]=xlsread(handles.ExcelFile,'NS1');
[a, mStudentNS2,cRawNS2]=xlsread(handles.ExcelFile,'NS2');
[a, mStudentDNS,cRawDNS]=xlsread(handles.ExcelFile,'DNS');

% Check if write file is loaded
%    errordlg ('Cadet file is not in correct format ... Please check')
%end
if  strcmp(mStudent(2,2),'')
    errordlg('Wrong excel file selected')
end
if (size(a,2)>3)
    handles.vScore = a(2:end,9);
end
mStudent(3:end,end+9) = cell(1);
handles.mStudent = mStudent(2:end,:);

cnames = {'ID','_____Cadet Name______','________EmailId________','0600','0830','0930','1040','1140','1340','1440','1540','SCORE'};
% Update data in to table
set(handles.uitable5,'data',handles.mStudent,'ColumnName',cnames);
%set(handles.uitable5,'data',mStudent);
guidata(hObject, handles);





% --- Executes when entered data in editable cell(s) in uitable5.
function uitable5_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable5 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in LoadAbsent.
function LoadAbsent_Callback(hObject, eventdata, handles)
% hObject    handle to LoadAbsent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%
clc
set(handles.sStatusMessage,'BackgroundColor','Blue');
set(handles.sStatusMessage,'ForegroundColor','White');

%% Make list of arrived mail
sStatusMsg = sprintf('\nFetching mails....');
set(handles.sStatusMessage,'String',sStatusMsg);
% loadMail()
addpath(pwd);
savepath;
load('MailData.mat')
sStatusMsg = sprintf('\nTotal %d mails fethced....',nCount);
set(handles.sStatusMessage,'String',sStatusMsg);
pause(0.01);
nProcessed = 1;
nAbsentCount =0;
pause(0.01);
sStatusMsg = sprintf('\nCreating file per day....',nCount);
set(handles.sStatusMessage,'String',sStatusMsg);
pause(0.02);
%%Create M files per day
% createMatPerDayPerCourse();
%%
n600 = 4;
%% ME1 Attendance calculation
handles = guidata(hObject);
if strcmpi(handles.sSheet,'ME1')
    
    
    sCourseName = handles.sSheet;
    sStruct = dir(fullfile(pwd,'MatData',sCourseName));
    nDays = numel(sStruct);
  
    sStatusMsg=sprintf('Processing Course : %s ...Total Days : %d',sCourseName,nDays);
    set(handles.sStatusMessage,'String',sStatusMsg);
    pause(0.01);
    handles.mStudent = genReport(sStruct,handles.mStudent,sCourseName,n600,handles);
    sReportFileName = [date,sCourseName,'.xlsx'];
    set(handles.uitable5,'data',handles.mStudent)
    [FileName,PathName] = uiputfile('*.xlsx','save attendance file as ...');
    mData = [handles.mStudent(:,1:3),handles.mStudent(:,end)];
    handles.SaveFile=fullfile(PathName,sReportFileName);
    mData{1,1}=nDays;
    xlswrite(handles.SaveFile,mData);
    % save(handles.SaveFile,'handles.mStudent');
    %% ME2 Attendance calculation
elseif strcmpi(handles.sSheet,'ME2')
    sCourseName = handles.sSheet;
    sStruct = dir(fullfile(pwd,'MatData',sCourseName));
    nDays = numel(sStruct);
     
    sStatusMsg=sprintf('Processing Course : %s ...Total Days : %d',sCourseName,nDays);
    set(handles.sStatusMessage,'String',sStatusMsg);
    pause(0.01);
    handles.mStudent = genReport(sStruct,handles.mStudent,sCourseName,n600);
    sReportFileName = [date,sCourseName,'.xlsx'];
    set(handles.uitable5,'data',handles.mStudent)
    [FileName,PathName] = uiputfile('*.xlsx','save attendance file as ...');
    handles.SaveFile=fullfile(PathName,sReportFileName);
    mData = [handles.mStudent(:,1:3),handles.mStudent(:,end)];
     mData{1,1}=nDays;
    xlswrite(handles.SaveFile,mData);
    %% NS1 Attendance Calculation
elseif strcmpi(handles.sSheet,'NS1')
    sCourseName = handles.sSheet;
    sStruct = dir(fullfile(pwd,'MatData',sCourseName));
    nDays = numel(sStruct);
    
    sStatusMsg=sprintf('Processing Course : %s ...Total Days : %d',sCourseName,nDays);
    set(handles.sStatusMessage,'String',sStatusMsg);
    pause(0.01);
    handles.mStudent = genReport(sStruct,handles.mStudent,sCourseName,n600);
    sReportFileName = [date,sCourseName,'.xlsx'];
    set(handles.uitable5,'data',handles.mStudent)
    [FileName,PathName] = uiputfile('*.xlsx','save attendance file as ...');
    handles.SaveFile=fullfile(PathName,sReportFileName);
    mData = [handles.mStudent(:,1:3),handles.mStudent(:,end)];
     mData{1,1}=nDays;
    xlswrite(handles.SaveFile,mData);
    %% NS2 Attendance Calculation
elseif strcmpi(handles.sSheet,'NS2')
    sCourseName = handles.sSheet;
    sStruct = dir(fullfile(pwd,'MatData',sCourseName));
    nDays = numel(sStruct);
    
    sStatusMsg=sprintf('Processing Course : %s ...Total Days : %d',sCourseName,nDays);
    set(handles.sStatusMessage,'String',sStatusMsg);
    pause(0.01);
    handles.mStudent = genReport(sStruct,handles.mStudent,sCourseName,n600);
    sReportFileName = [date,sCourseName,'.xlsx'];
    set(handles.uitable5,'data',handles.mStudent)
    [FileName,PathName] = uiputfile('*.xlsx','save attendance file as ...');
    handles.SaveFile=fullfile(PathName,sReportFileName);
    mData = [handles.mStudent(:,1:3),handles.mStudent(:,end)];
    mData{1,1}=nDays;
    xlswrite(handles.SaveFile,mData);
    %%
else
    sCourseName = 'DNS1';
    sStruct = dir(fullfile(pwd,'MatData',sCourseName));
    nDays = numel(sStruct);
    
    sStatusMsg=sprintf('Processing Course : %s ...Total Days : %d',sCourseName,nDays);
    set(handles.sStatusMessage,'String',sStatusMsg);
    pause(0.01);
    handles.mStudent = genReport(sStruct,handles.mStudent,sCourseName,n600);
    sReportFileName = [date,sCourseName,'.xlsx'];
    set(handles.uitable5,'data',handles.mStudent)
    [FileName,PathName] = uiputfile('*.xlsx','save attendance file as ...');
    handles.SaveFile=fullfile(PathName,sReportFileName);
    mData = [handles.mStudent(:,1:3),handles.mStudent(:,end)];
    mData{1,1}=nDays;
    xlswrite(handles.SaveFile,mData);
    %%
end

%fprintf('\n mail processed n Processed %d/ iMail %d \t',nProcessed,iMail)
%sStatusMsg=sprintf('%s ... %d/ / %d',sSubject,nProcessed,nCount);
%set(handles.sStatusMessage,'String',sStatusMsg);
%pause(0.01);



% Calculate score of each candidate
h = msgbox(sprintf('Report File %s generated successfully',sReportFileName));
%% THE END %%



guidata(hObject, handles);


% --- Executes on button press in SaveFile.
function SaveFile_Callback(hObject, eventdata, handles)
% hObject    handle to SaveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uiputfile('*.xlsx','save attendance file as ...');
handles.SaveFile=fullfile(PathName,FileName);

xlswrite(handles.SaveFile,handles.mStudent)
beep
pause(0.5)
beep


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SendMail.
function SendMail_Callback(hObject, eventdata, handles)
% hObject    handle to SendMail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myaddress = 'attimu@tmi.tolani.edu';
mypassword = 'attimu123';

setpref('Internet','E_mail',myaddress);
setpref('Internet','SMTP_Server','192.168.55.12');
setpref('Internet','SMTP_Username',myaddress);
setpref('Internet','SMTP_Password',mypassword);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
    'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% [FileName,PathName]=uigetfile('*.xlsx', 'Select Attachment file');
% sExcelFile=fullfile(PathName,FileName);
sMessage =  ['Attendance Report  ' date];
%sendmail(myaddress, sMessage, 'Please find attached.',sExcelFile);




%% Logic to calculate to whom we shall send mail
nSend=4;
for iSend = 2:nSend
    sEmail=handles.mStudent(iSend,3);
    sendmail(sEmail, sMessage, 'This is mail in loop');
end

beep



function date_Callback(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of date as text
%        str2double(get(hObject,'String')) returns contents of date as a double

handles.mStudent(1,2) ={handles.date.String} ;

set(handles.uitable5,'data',handles.mStudent)

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable6.
function uitable6_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable6 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox18.
function checkbox18_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.sSheet= contents{get(hObject,'Value')};
sStatusMsg=sprintf('Processing course : %s ',handles.sSheet);
set(handles.sStatusMessage,'String',sStatusMsg);
pause(0.01);
if strcmpi(handles.sSheet, 'ME1')
    [a, mStudent,cRawME1]=xlsread(handles.ExcelFile,'ME1');
    
elseif strcmpi(handles.sSheet, 'ME2')
    [a, mStudent,cRawME2]=xlsread(handles.ExcelFile,'ME2');
    vID =  cellstr(num2str(a));
    mStudent(3:2+size(a,1),1) = vID;
elseif strcmpi(handles.sSheet, 'NS1')
    [a, mStudent,cRawNS1]=xlsread(handles.ExcelFile,'NS1');
elseif strcmpi(handles.sSheet, 'NS2')
    [a, mStudent,cRawNS2]=xlsread(handles.ExcelFile,'NS2');
    vID =  cellstr(num2str(a));
    mStudent(3:2+size(a,1),1) = vID;
elseif strcmpi(handles.sSheet(1:3), 'DNS')
    [a, mStudent,cRawDNS]=xlsread(handles.ExcelFile,'DNS1');
    handles.sSheet = 'DNS1';
else
    [a, mStudent,cRawME1]=xlsread(handles.ExcelFile,'ME1');
end
if  strcmp(mStudent(2,2),'')
    errordlg('Wrong excel file selected')
end
if (size(a,2)>3)
    handles.vScore = a(2:end,9);
end
mStudent(3:end,end+9) = cell(1);
handles.mStudent = mStudent(2:end,:);

cnames = {'ID','_____Cadet Name______','________EmailId________','0600','0830','0930','1040','1140','1340','1440','1540','SCORE'};
% Update data in to table
set(handles.uitable5,'data',handles.mStudent,'ColumnName',cnames);
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sStatusMessage_Callback(hObject, eventdata, handles)
% hObject    handle to sStatusMessage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sStatusMessage as text
%        str2double(get(hObject,'String')) returns contents of sStatusMessage as a double


% --- Executes during object creation, after setting all properties.
function sStatusMessage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sStatusMessage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','Blue');
end



function CommandWindow_Callback(hObject, eventdata, handles)
% hObject    handle to CommandWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CommandWindow as text
%        str2double(get(hObject,'String')) returns contents of CommandWindow as a double


% --- Executes during object creation, after setting all properties.
function CommandWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CommandWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
