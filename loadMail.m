function loadMail()
%% Connecting to Outlook
outlook = actxserver('Outlook.Application');
mapi=outlook.GetNamespace('mapi');
INBOX=mapi.GetDefaultFolder(6);

%% Retrieving last email
nCount = INBOX.Items.Count; %index of the most recent email.\
fprintf('\nTotal %d mails fethced....',nCount);
fprintf('\nProcessing mails please wait....\n');

%% Make list of arrived mail
for iMail =1 :nCount
    email=INBOX.Items.Item(iMail); %imports the most recent email
    
    sSubject = email.get('Subject');
    sBody = email.get('Body');
    mMailData{iMail,1}= sSubject;
    mMailData{iMail,2}=sBody;
end
save('MailData.mat','mMailData','nCount');
fprintf('\n=====================================');
fprintf('\n file MailData.mat generated sucessfully ...');
fprintf('\n=====================================');
end