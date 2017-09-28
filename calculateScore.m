function [mStudent] = calculateScore(mStudent,n600)
mData = cell2mat(mStudent(:,n600:end-1));
[vRow,vCol] = find(mData==0);
mScore = 0.5*ones(size(mData,1),2);
 vScore = cell2mat(mStudent(:,end));
 if isempty(vScore)
     vScore = zeros(size(mStudent(:,end)));
 end
for iRow = 1:numel(vRow)
    
    if vCol(iRow) < 4   % forenoon session absent FOURTH row
        mScore(vRow(iRow), 1) = 0;
        
    else   % afternoon session absent
        mScore(vRow(iRow),2)= 0.;
        
        
    end
end
vScoreTemp = sum(mScore,2);
vScore = vScore+vScoreTemp;
mStudent(:,end)=num2cell(vScore);

end