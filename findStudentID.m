function nIdx = findStudentID(vId,cCell)
    sAbsent = cell2str(cCell);
    sAbsent =sAbsent(3:end-3);
    nIdx = strcmpi(vId,sAbsent);                
%Logic find absent students in list
% nIdx = not(cellfun('isempty',idx));
if nnz(nIdx) == 0
    sAbsent = removeSpace(sAbsent);                 
    nIdx = strcmpi(vId,sAbsent);   
   % nIdx = not(cellfun('isempty',idx));
end                  
end