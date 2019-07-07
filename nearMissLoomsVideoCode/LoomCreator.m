classdef LoomCreator < handle
  properties
    ScreenWidth
    ScreenHeight
    Outfile
    VideoObj
  end
  
  methods
    function obj = LoomCreator(width, height, outfile)
      obj.ScreenWidth = width;
      obj.ScreenHeight = height;
      obj.Outfile = outfile;
      
      % setup video and figure
      obj.initVideo()
      obj.initFigure()
    end
    
    % sets up the video writer
    function obj = initVideo(obj)
      profile = 'MPEG-4';
      obj.VideoObj = VideoWriter(obj.Outfile, profile);
      obj.VideoObj.Quality = 100;
      obj.VideoObj.FrameRate = 120;
      open(obj.VideoObj);
    end
    
    % set up the figure/plot params, sizes, etc.
    function initFigure(obj)
%       figure
       % TODO: any other styling
    end
    
%     function run(obj)
%       obj.addCoordinateVectors()
%     end
    
    function addCoordinateVectors(obj, X_L, X_C, X_R)
      for i = 1:length(X_L)
        obj.addPolygon(X_L(i), X_C(i), X_R(i))
      end
    end
   
    % x_L represents the x coordinate of the left side of the polygon
    % x_C represents the x coordinate of the center of the polygon
    % x_R represents the x coordinate of the right side of the polygon
    % the y values can be calculated from these variables (apparently...)
    function addPolygon(obj, x_L, x_C, x_R)    
      [x_L, x_C, x_R]
      
      
      % calculate all of the coordinates of the polygon to project (see
      % paper drawing)
      top_left_x = x_L;
      top_left_y = x_C - x_L;
      top_right_x = x_R;
      top_right_y = x_R - x_C;
      bottom_right_x = top_right_x;
      bottom_right_y = -top_right_y;
      bottom_left_x = top_left_x;
      bottom_left_y = -top_left_y;
      
      % plot the polygon
      X = [top_left_x, top_right_x, bottom_right_x, bottom_left_x];
      Y = [top_left_y, top_right_y, bottom_right_y, bottom_left_y];
      p = polyshape(X, Y);
      rbg = [0 0 0];
      plot(p, 'FaceColor', rbg, 'FaceAlpha', 1.0)
      
      % set the figure width & height to match that for the video
      w = obj.ScreenWidth / 2;
      h = obj.ScreenHeight / 2;
      xlim([-w w])
      ylim([-h h])
      set(gcf,'Position',[0 0 obj.ScreenWidth obj.ScreenHeight])
      
      % capture frame, save to video
      F = getframe;
      obj.addFrame(F)
    end
    
    % adds a FRAME struct to the current video
    function addFrame(self, frame)
      writeVideo(self.VideoObj, frame)
    end
    
    function saveVideo(self)
      close(self.VideoObj)
    end
  end
  
  % Class Methods
  methods (Static)
    function [L] = default(outfile)
      IPAD_WIDTH = 1920;
      IPAD_HEIGHT = 1080;
      L = LoomCreator(IPAD_WIDTH, IPAD_HEIGHT, outfile);
    end
  end
end

