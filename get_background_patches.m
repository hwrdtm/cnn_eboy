% pixorama dir

pixorama_dir = 'data/pixorama/';

% next pic

next_pic = 'EBY-Rio-Poster-34k.png';

% output dir

output_dir = 'data/patches/ebyrio/';

im = imread(fullfile(pixorama_dir,next_pic));

% stride lengths - each patch will be 50 tall x 30 wide and the patches
% will not overlap.

xstride = 30;
ystride = 50;

% File number
fnum = 0;

for y = 1:50:size(im,1)
   for x = 1:30:size(im,2)
       % Generate next file number
       fnum = fnum + 1;
       fname = strcat(output_dir, 'ebyrio_',num2str(fnum),'.png');

       % Save patch
       cond1 = (y+49) > size(im,1);
       cond2 = (x+29) > size(im,2);
       
       % Handle edge conditions
       if cond1 && cond2
           imwrite(im(end-49:end,end-29:end,:), fname);
       elseif cond1
           imwrite(im(end-49:end,x:x+29,:), fname);
       elseif cond2
           imwrite(im(y:y+49,end-29:end,:), fname);
       else
           imwrite(im(y:y+49,x:x+29,:), fname);
       end
   end
end