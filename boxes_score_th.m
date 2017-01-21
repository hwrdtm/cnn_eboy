function [boxes, score] = boxes_score_th(boxes_score, th)
for i = 1:size(boxes_score,1)
if boxes_score(i,5) < th
boxes_score(i,:) = 0;
end
end
boxes_score( all(~boxes_score,2), : ) = [];                 % remove zero rows


boxes = boxes_score(:,1:4);
score = boxes_score(:,5);
end