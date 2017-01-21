function object = identifyObject(im)
    % object = (x,y,R,G,B)
    
    % object is described using an array of [object; object ... ]
    % so object = [( ... ); ( ... ); ... ( ... );]
    
    object = zeros(1,5);
    
    % consts
    IMG_HEIGHT = size(im,1);
    IMG_WIDTH = size(im,2);
    IMG_CHAN = size(im,3);
    
    % [x y]
    prev_non_white = [-100 -100];

    for y = 1:IMG_HEIGHT
       for x = 1:IMG_WIDTH   
           if isWhitePixel(im(y,x,:))
               continue
           else
               % If this pixel is in vicinity of prev_non_white pixel
               % then this pixel must be linked to the previous tracked
               % image.
               cond1 = ((prev_non_white(1) - 1) < x) && ((prev_non_white(1) + 1) > x);
               cond2 = ((prev_non_white(2) - 1) < y) && ((prev_non_white(2) + 1) > y);
               
               if (cond1 && cond2)
                   continue
               end
               
               this_pixel = [x y im(y,x,1) im(y,x,2) im(y,x,3)];
               prev_non_white = [x y];
               object = traceObject(this_pixel,object,im);
               
               fprintf('HITTT\n');
           end
       end
    end
    
    % Trim all zero rows
    object = object(any(object,2),:);
end

function boo = isWhitePixel(pixel)
    cond1 = pixel(:,:,1) == 255;
    cond2 = pixel(:,:,2) == 255;
    cond3 = pixel(:,:,3) == 255;
    
    if cond1 && cond2 && cond3
       boo = true;
    else
       boo = false;
    end
end

function object = traceObject(pixel,object,im)
    % TODO
    % Add this pixel to object if not already added
    if checkPixelExist(pixel,object) == 0
        object = [object; pixel];
    end
    
    % Find neighboring non-white pixel
    next_pixels = findNeighborPixels(pixel,object,im);
    
    % Since next_pixels are padded with starting [0 0 0 0 0]
    % array, ignore first row.
    
    % Go to neighboring non-white pixel
    if size(next_pixels,1) ~= 1
        % Recursion breaking condition: if all pixels you want
        % to go to have already been added to object.
        exist_count = 0;
        for ind = 2:size(next_pixels,1)
            if checkPixelExist(next_pixels(ind,:),object) == 1
               exist_count = exist_count + 1;
            end
        end
        if exist_count == (size(next_pixels,1) - 1)
            fprintf('hit\n');
            return; 
        end
        
        % Remember, starting index for next_pixels is 2
        for ind = 2:size(next_pixels,1)
            if checkPixelExist(next_pixels(ind,:),object) == 0
               object = traceObject(next_pixels(ind,:),object,im);
            end
        end
    end
end

function boo = checkPixelExist(pixel,object)
    boo = false;
    for row = 1:size(object,1)
        % Check for existing position is already enough
        cond1 = object(row,1) == pixel(1);
        cond2 = object(row,2) == pixel(2);
        
        if cond1 && cond2
           boo = true;
           break;
        end
    end
end

function next_pixels = findNeighborPixels(pixel,object,im)
    % Use zeros() function to define the dimensions of the
    % growing next_pixels array. So, essentially pad each
    % next_pixels array with starting [0 0 0 0 0] row.
    next_pixels = zeros(1,5);
    
    % consts
    IMG_HEIGHT = size(im,1);
    IMG_WIDTH = size(im,2);
    
    % Window is 3x3 around centre pixel
    WINDOW_XSTART = pixel(1) - 1;
    if WINDOW_XSTART < 0
        WINDOW_XSTART = 0;
    end
    WINDOW_XEND = pixel(1) + 1;
    if WINDOW_XEND > IMG_WIDTH
       WINDOW_XEND = IMG_WIDTH;
    end
    WINDOW_YSTART = pixel(2) - 1;
    if WINDOW_YSTART < 0
       WINDOW_YSTART = 0; 
    end
    WINDOW_YEND = pixel(2) + 1;
    if WINDOW_YEND > IMG_WIDTH
       WINDOW_YEND = IMG_WIDTH; 
    end
    
    for y = WINDOW_YSTART:WINDOW_YEND
       for x = WINDOW_XSTART:WINDOW_XEND
           % skip over original pixel
           if (x == pixel(1)) && (y == pixel(2))
              continue 
           end
           
           if isWhitePixel(im(y,x,:))
               continue
           else
               next_pixels = [next_pixels; x y im(y,x,1) im(y,x,2) im(y,x,3)];
           end
       end
    end
end