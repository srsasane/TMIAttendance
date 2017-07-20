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

% Last Modified by GUIDE v2.5 06-Jul-2017 08:47:49

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
[FileName,PathName]=uigetfile('*.xlsx', 'Select Cadet list file');
handles.ExcelFile=fullfile(PathName,FileName);
[a, mStudent]=xlsread(handles.ExcelFile);
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
%% Connecting to Outlook
outlook = actxserver('Outlook.Application');
mapi=outlook.GetNamespace('mapi');
INBOX=mapi.GetDefaultFolder(6);

%% Retrieving last email
nCount = INBOX.Items.Count; %index of the most recent email.\
for iMail =1: nCount
    email=INBOX.Items.Item(iMail); %imports the most recent email
    
    sSubject = email.get('Subject');
    sBody = email.get('Body');
    C = textscan(sSubject,'%s','Delimiter',',');
    vSubject = cell (C{1,1});
    
    C = textscan(sBody,'%s','Delimiter',',');
    vAbsent = cell(C{1,1});
    
    %% Check if format of message is correct
    %     for iChk=2:size(vAbsent,1)
    %
    %     end
    %%
    
    n600 = 4;
    
    set(handles.uitable6,'data',vAbsent);
    vId = handles.mStudent(:,1);
    nRow = 1;
    %% Logic to find hours in absent student list
    vHourId = zeros(1,8);
    vHourColumn= zeros(1,8);
    for iHours=1:size(vAbsent,1)
        if strcmp(vAbsent(iHours),'0600')
            vHourColumn(1) = n600;
            vHourId(1) = iHours;
            if cellfun('isempty',handles.mStudent(nRow,n600))
                % Mark all student present for 0600 hours class
                handles.mStudent(nRow:end,vHourColumn(1))={2};
                
            end
        elseif strcmp(vAbsent(iHours),'0830')
            vHourColumn(2) = n600+1;
            vHourId(2) = iHours;
            if cellfun('isempty',handles.mStudent(nRow,n600+1))
                % Mark all student present for 0830 hours class
                handles.mStudent(nRow:end,vHourColumn(2))={2};
            end
        elseif strcmp(vAbsent(iHours),'0930')
            vHourColumn(3)= n600+2;
            vHourId(3) = iHours;
            if cellfun('isempty',handles.mStudent(nRow,n600+2))
                % Mark all student present for 0930 hours class
                handles.mStudent(nRow:end,n600+2)={2};
            end
        elseif strcmp(vAbsent(iHours),'1040')
            vHourColumn (4)= n600+3;
            vHourId(4) = iHours;
            if cellfun('isempty',handles.mStudent(nRow, n600+3))
                % Mark all student present for 1040 hours class
                handles.mStudent(nRow:end, n600+3)={2};
            end
        elseif strcmp(vAbsent(iHours),'1140')
            vHourColumn(5) =n600+4;
            vHourId(5) = iHours;
            if cellfun('isempty',handles.mStudent(nRow,n600+4))
                % Mark all student present for 1140 hours class
                handles.mStudent(nRow:end,n600+4)={2};
            end
        elseif strcmp(vAbsent(iHours),'1340')
            vHourColumn(6) = n600+5;
            vHourId(6) = iHours;
            % Mark all student present for 1340 hours class
            if cellfun('isempty',handles.mStudent(nRow,n600+5))
                handles.mStudent(nRow:end,n600+5)={2};
            end
        elseif strcmp(vAbsent(iHours),'1440')
            vHourColumn(7) =n600+6;
            vHourId(7) = iHours;
            if cellfun('isempty',handles.mStudent(nRow,n600+6))
                % Mark all student present for 1440 hours class
                handles.mStudent(nRow:end,n600+6)={2};
            end
        elseif strcmp(vAbsent(iHours),'1540')
            vHourColumn(8) = n600+7;
            vHourId(8) = iHours;
            if cellfun('isempty',handles.mStudent(nRow,n600+7))
                % Mark all student present for 1540 hours class
                handles.mStudent(nRow:end,n600+7)={2};
            end
            %   else
            %      error('Absent Text file is NOT in intended format ... Please check');
            
        end
        %Find absent candet
    end
    %% Logic to make student absent
    
    for iHour=1:size(vHourId,2)
        if vHourId(iHour)~=0
            
            if isequal(vHourId(iHour),1)&& isequal(iMail,1)
                if ~isempty(strfind(handles.mStudent(4),'ME'))
                    h = msgbox('You are updating Marine Engineering course attendance','TMI Attendance 1.2');
                    
                elseif~isempty(strfind(handles.mStudent(4),'NS'))
                    h = msgbox('You are updating Nautical Science course attendance','TMI Attendance 1.2');
                    
                elseif  ~isempty(strfind(handles.mStudent(4),'DNS'))
                    h = msgbox('You are updating Diploma in Nautical Science course attendance','TMI Attendance 1.2');
                    
                end
                if strcmp(vAbsent(vHourId(iHour)+1),'2016ME')
                    sMsg =['Cadet ID is wrong in ', sSubject ,' mail... Please check'];
                    errordlg (sMsg)
                end
                for iAbsent = 2:size(vAbsent,1)
                    idx = strfind(vId,vAbsent{iAbsent});
                    if isempty(idx)
                        errordlg ('Cadet file is not in correct format ... Please check')
                    end
                    %Logic find absent students in list
                    nIdx = not(cellfun('isempty',idx));
                    handles.mStudent{nIdx,vHourColumn(iHour)}=1;
                end
            end
        end
    end
end

%% LOGIC TO LOAD CADET FILES FROM FOLDER
%Get directory containing text files of absent cadets
% sPathName=uigetdir;
% handles.AbsentDir=fullfile(sPathName,'*.txt');
% handles.AbsentFile = dir (handles.AbsentDir);
% % Iterate through absent files
% for i=1:size(handles.AbsentFile,1)
%     sAbsentFileName = fullfile(sPathName,handles.AbsentFile(i).name);
%     fileID=fopen(sAbsentFileName);
%     C = textscan(fileID,'%s','Delimiter',',');
%     vAbsent = cell(C{1,1});
%     set(handles.uitable6,'data',vAbsent);
%     vId = handles.mStudent(:,1);
%     nRow = 1;
%     if strcmp(vAbsent(1),'0600')
%         nColumn = 3;
%
%         if cellfun('isempty',handles.mStudent(nRow,nColumn))
%             % Mark all student present for 0600 hours class
%             handles.mStudent(nRow:end,nColumn)={2};
%
%         end
%     elseif strcmp(vAbsent(1),'0830')
%         nColumn = 4;
%         if cellfun('isempty',handles.mStudent(nRow,nColumn))
%             % Mark all student present for 0830 hours class
%             handles.mStudent(nRow:end,nColumn)={2};
%         end
%     elseif strcmp(vAbsent(1),'0930')
%         nColumn = 5;
%         if cellfun('isempty',handles.mStudent(nRow,nColumn))
%             % Mark all student present for 0930 hours class
%             handles.mStudent(nRow:end,nColumn)={2};
%         end
%     elseif strcmp(vAbsent(1),'1040')
%         nColumn = 6;
%         if cellfun('isempty',handles.mStudent(nRow,nColumn))
%             % Mark all student present for 1040 hours class
%             handles.mStudent(nRow:end,nColumn)={2};
%         end
%     elseif strcmp(vAbsent(1),'1140')
%         nColumn = 7;
%         if cellfun('isempty',handles.mStudent(nRow,nColumn))
%             % Mark all student present for 1140 hours class
%             handles.mStudent(nRow:end,nColumn)={2};
%         end
%     elseif strcmp(vAbsent(1),'1340')
%         nColumn = 8;
%         % Mark all student present for 1340 hours class
%         if cellfun('isempty',handles.mStudent(nRow,nColumn))
%             handles.mStudent(nRow:end,nColumn)={2};
%         end
%     elseif strcmp(vAbsent(1),'1440')
%         nColumn = 9;
%         if cellfun('isempty',handles.mStudent(nRow,nColumn))
%             % Mark all student present for 1440 hours class
%             handles.mStudent(nRow:end,nColumn)={2};
%         end
%     elseif strcmp(vAbsent(1),'1540')
%         nColumn = 10;
%         if cellfun('isempty',handles.mStudent(nRow,nColumn))
%             % Mark all student present for 1540 hours class
%             handles.mStudent(nRow:end,nColumn)={2};
%         end
%     else
%         error('Absent Text file is NOT in intended format ... Please check');
%
%     end
%     %Find absent candet
%     for j=2:size(vAbsent,1);
%         idx = strfind(vId,vAbsent{j});
%         nIdx = not(cellfun('isempty',idx));
%         handles.mStudent{nIdx,nColumn}=1;
%     end
%     fclose(fileID);
% end
% Calculate score of each candidate
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
