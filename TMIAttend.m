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
%% Connecting to Outlook
outlook = actxserver('Outlook.Application');
mapi=outlook.GetNamespace('mapi');
INBOX=mapi.GetDefaultFolder(6);

%% Retrieving last email
nCount = INBOX.Items.Count; %index of the most recent email.\
fprintf('\nTotal %d mails fethced....',nCount);
fprintf('\nProcessing mails please wait....\n');
sStatusMsg = sprintf('\nTotal %d mails fethced....',nCount);
set(handles.sStatusMessage,'String',sStatusMsg);
pause(0.01);
%% Make list of arrived mail
% nProcessed = 1;
for iMail =1 :nCount
    email=INBOX.Items.Item(iMail); %imports the most recent email
    
    sSubject = email.get('Subject');
    sBody = email.get('Body');
    mMailData{iMail,1}= sSubject;
    mMailData{iMail,2}=sBody;
end
save('MailData.mat','mMailData','nCount');
%load('MailData.mat')
nProcessed = 1;
nAbsentCount =0;
%% ----Create Individual mat file per date
for iMail =1: nCount
    %    iMail = nCount; %DELETE ME
    break;
    sSubject =  mMailData{iMail,1};
    
    sBody = mMailData{iMail,2};
    C = textscan(sSubject,'%s','Delimiter',',');
    vSubject = cell (C{1,1});
    sCourseYear= strcat(vSubject(1),vSubject(2));
    
    if strcmp(vSubject(1),'DNS')
        if strcmp(vSubject(2),'1')
            sDate = datestr(datenum(vSubject(3),'dd/mm/yyyy'));
            sMatFile = fullfile(pwd,'MatData',[sDate,'.mat']);
            save(sMatFile,'sBody');
        else
            sDate = datestr(datenum(vSubject(2),'dd/mm/yyyy'));
            sMatFile = fullfile(pwd,'MatData',[sDate,'.mat']);
            save(sMatFile,'sBody');
        end
    else
        
        sDate = datestr(datenum(vSubject(3),'dd/mm/yyyy'));
        sMatFile = fullfile(pwd,'MatData',[sDate,'.mat']);
        save(sMatFile,'sBody');
    end
    %     fprintf('\n mail processed %d \t',iMail)
end
%%
n600 = 4;


for iMail =1: nCount
    %% update me
    %     iMail = 2100 +1;
    %%
    
    %     iMail
    sSubject =  mMailData{iMail,1};
    sBody = mMailData{iMail,2};
    %     set(handles.CommandWindow,'String',sBody);
    %     set(handles.sStatusMessage,'String',sSubject);
    %     pause(0.1);
    disp(sSubject);
    disp(sBody);
    C = textscan(sSubject,'%s','Delimiter',',');
    vSubject = cell (C{1,1});
    sCourseYear= strcat(vSubject(1),vSubject(2));
    C = textscan(sBody,'%s','Delimiter',',');
    vAbsent = cell(C{1,1});
    
    %% Adjust course name when DNS
    if strcmpi(sCourseYear,'ME1')
        
        %         continue;
    elseif strcmpi(sCourseYear,'ME2')
        %         continue;
    elseif strcmpi(sCourseYear,'NS1')
        %         continue;
    elseif strcmpi(sCourseYear,'NS2')
        %         continue;
    elseif strcmpi(sCourseYear,'DNS1')
        %         continue;
        
    else
        %         disp('hello')
        sCourseYear = cell2str(sCourseYear);
        sCourseYear=[sCourseYear(3:5),'1'];
        
        %         disp(sCourseYear)
    end
    %%
    
    
    set(handles.uitable6,'data',vAbsent);
    vId = handles.mStudent(:,1);
    nRow = 1;
    %     vCourse(iMail) =sCourseYear;
    disp(sCourseYear)
    %          if strcmpi(sCourseYear,'ME1')
    %          elseif strcmpi(sCourseYear,'ME2')
    %
    %          elseif strcmpi(sCourseYear,'NS1')
    %          elseif strcmpi(sCourseYear,'NS2')
    %              elseif strcmpi(sCourseYear,'DNS')
    %
    %          end
    %% logic to update specific year
    if strcmpi(sCourseYear,handles.sSheet)
        %         disp(sCourseYear)
        
        %% Logic to find hours in absent student list
        vHourId = zeros(1,8);
        vHourColumn= zeros(1,8);
        %% Logic that adds attendance of time slot 0600
        vHourColumn(1) = n600;
        
        if cellfun('isempty',handles.mStudent(nRow,n600))
            % Mark all student present for 0600 hours class
            handles.mStudent(nRow:end,vHourColumn(1))={2};
            
        end
        
        %%
        %         sMatFile =
        v0830 = [];
        v0930 = [];
        v1040 = [];
        v1140 = [];
        v1340 = [];
        v1440 = [];
        v1540 = [];
        % Update processed mail count.
        nProcessed = 1+nProcessed;
        for iHours = 1:size(vAbsent,1)
            if strcmp(vAbsent(iHours),'0830')
                sHourID = vAbsent(iHours);
            elseif strcmp(vAbsent(iHours),'0930')
                sHourID = vAbsent(iHours);
            elseif strcmp(vAbsent(iHours),'1040')
                sHourID = vAbsent(iHours);
            elseif strcmp(vAbsent(iHours),'1140')
                sHourID = vAbsent(iHours);
            elseif strcmp(vAbsent(iHours),'1340')
                sHourID = vAbsent(iHours);
            elseif strcmp(vAbsent(iHours),'1440')
                sHourID = vAbsent(iHours);
            elseif strcmp(vAbsent(iHours),'1540')
                sHourID = vAbsent(iHours);
            elseif strcmp(vAbsent(iHours),'1240')
                
                error('Wrong HourID !!')
                
            end
            if strcmp(sHourID,'0830')
                if strcmp(vAbsent(iHours),'0830')
                    
                    idx0830 = 1;
                end
                v0830{idx0830} = vAbsent(iHours);
                idx0830 = idx0830+1;
            elseif strcmp(sHourID,'0930')
                if strcmp(vAbsent(iHours),'0930')
                    
                    idx0930 = 1;
                end
                v0930{idx0930} = vAbsent(iHours);
                idx0930 = idx0930+1;
            elseif strcmp(sHourID,'1040')
                if strcmp(vAbsent(iHours),'1040')
                    
                    idx1040 = 1;
                end
                v1040{idx1040} = vAbsent(iHours);
                idx1040 = idx1040+1;
            elseif strcmp(sHourID,'1140')
                if strcmp(vAbsent(iHours),'1140')
                    
                    idx1140 = 1;
                end
                v1140{idx1140} = vAbsent(iHours);
                idx1140 = idx1140 +1;
                
            elseif strcmp(sHourID,'1340')
                if strcmp(vAbsent(iHours),'1340')
                    
                    idx1340 =1;
                end
                v1340{idx1340} = vAbsent(iHours);
                idx1340 = idx1340+1;
            elseif strcmp(sHourID,'1440')
                if strcmp(vAbsent(iHours),'1440')
                    
                    idx1440 = 1;
                end
                v1440{idx1440} = vAbsent(iHours);
                idx1440 = idx1440+1;
            elseif strcmp(sHourID,'1540')
                if strcmp(vAbsent(iHours),'1540')
                    
                    idx1540 = 1;
                end
                v1540{idx1540} = vAbsent(iHours);
                idx1540 = idx1540 +1;
            end
        end
        
        
        %% Logic to make student absent
        if ~isempty(v0830)
            handles.mStudent(nRow:end,n600+1)={2};
            for iAbsent =2:numel(v0830)
                if strcmpi(v0830{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v0830{iAbsent});
                
                handles.mStudent{nIdx,n600+1}=1;
            end
            set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v0930)
            handles.mStudent(nRow:end,n600+2)={2};
            for iAbsent =2:numel(v0930)
                if strcmpi(v0930{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v0930{iAbsent});
                handles.mStudent{nIdx,n600+2}=1;
            end
            set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v1040)
            handles.mStudent(nRow:end,n600+3)={2};
            for iAbsent =2:numel(v1040)
                if strcmpi(v1040{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v1040{iAbsent});
                handles.mStudent{nIdx,n600+3}=1;
            end
            set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v1140)
            handles.mStudent(nRow:end,n600+4)={2};
            for iAbsent =2:numel(v1140)
                if strcmpi(v1140{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v1140{iAbsent});
                handles.mStudent{nIdx,n600+4}=1;
            end
            set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v1340)
            handles.mStudent(nRow:end,n600+5)={2};
            for iAbsent =2:numel(v1340)
                if strcmpi(v1340{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v1340{iAbsent});
                handles.mStudent{nIdx,n600+5}=1;
            end
            set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v1440)
            handles.mStudent(nRow:end,n600+6)={2};
            for iAbsent =2:numel(v1440)
                if strcmpi(v1440{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v1440{iAbsent});
                handles.mStudent{nIdx,n600+6}=1;
            end
            set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v1540)
            handles.mStudent(nRow:end,n600+7)={2};
            for iAbsent =2:numel(v1540)
                if strcmpi(v1540{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v1540{iAbsent});
                handles.mStudent{nIdx,n600+7}=1;
            end
            set(handles.uitable5,'data',handles.mStudent)
        end
        
        %     elseif
        
    end
    fprintf('\n mail processed n Processed %d/ iMail %d \t',nProcessed,iMail)
    sStatusMsg=sprintf('%s ... %d/ / %d',sSubject,nProcessed,nCount);
    set(handles.sStatusMessage,'String',sStatusMsg);
    pause(0.01);
end


% Calculate score of each candidate
h = msgbox(sprintf('Total mail %d /%d analysed ...',nProcessed,nCount));
mData = cell2mat(handles.mStudent(:,n600:end));
[vRow,vCol] = find(mData==1);
mScore = 2*ones(size(mData,1),2);

for iRow = 1:numel(vRow)
    
    if vCol(iRow) < 4    % forenoon session absent
        mScore(vRow(iRow), 1) = 1;
        
    else   % afternoon session absent
        mScore(vRow(iRow),2)= 1;
        
        
    end
end
vScore = sum(mScore,2);
if ~ exist('handles.vScore', 'var')
    handles.vScore = zeros(size(vScore));
end

handles.vScore = handles.vScore+vScore;
handles.mStudent(:,end)=num2cell(handles.vScore);
set(handles.uitable5,'data',handles.mStudent)

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
