function [mStudent] = calculateScore(mStudent,n600)
mData = cell2mat(mStudent(:,n600:end-1));
[vRow,vCol] = find(mData==1);
mScore = 2*ones(size(mData,1),2);
 vScore = cell2mat(mStudent(:,end));
 if isempty(vScore)
     vScore = zeros(size(mStudent(:,end)));
 end
for iRow = 1:numel(vRow)
    
    if vCol(iRow) < 4    % forenoon session absent
        mScore(vRow(iRow), 1) = 1;
        
    else   % afternoon session absent
        mScore(vRow(iRow),2)= 1;
        
        
    end
end
vScoreTemp = sum(mScore,2);
vScore = vScore+vScoreTemp;
mStudent(:,end)=num2cell(vScore);

end