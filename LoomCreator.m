classdef LoomCreator < handle
  properties
    ScreenWidth
    ScreenHeight
    Outfile
    VideoObj
    FigureHandle
  end
  
  methods
    function obj = LoomCreator(width, height, outfile)
      obj.ScreenWidth = width;
      obj.ScreenHeight = height;
      obj.Outfile = outfile;
      obj.VideoObj = []; 
      
      % setup video and figure
      obj.initVideo()
      obj.initFigure()
    end
    
    % sets up the video writer
    function obj = initVideo(obj)
      profile =  'Motion JPEG AVI'; % 'MPEG-4';
      obj.VideoObj = VideoWriter(obj.Outfile, profile );
      % todo preset video height and width for the initial frame
      
      obj.VideoObj.Quality = 100;
      obj.VideoObj.FrameRate = 120;
      open(obj.VideoObj);
    end
    
    % set up the figure/plot params, sizes, etc.
    function initFigure(obj)
      
      obj.FigureHandle = figure('visible', 'off');
      
      set(gca, 'box', 'off', 'XTickLabel', [], 'xtick', [], 'YTickLabel', [], 'ytick', [])
      set(gca,'visible','off')
      
%       set(gca.FigureHandle,'YTickLabel',[]);
%       set(gca.FigureHandle,'XTickLabel',[]);
%       set(gca.FigureHandle,'xtick',[])
%       set(gca.FigureHandle,'ytick',[])
%       
      
      
       % TODO: any other styling
    end
    
    function addCoordinateVectors(obj, X_L, X_C, X_R, photoDiodeSquareON )
      %length(X_L);
      for i = 1:length(X_L)
        i
        obj.addPolygonAndMarkerForPhotodiode(X_L(i), X_C(i), X_R(i) , photoDiodeSquareON(i) )
        
      end
    end
   
    % x_L represents the x coordinate of the left side of the polygon
    % x_C represents the x coordinate of the center of the polygon
    % x_R represents the x coordinate of the right side of the polygon
    % the y values can be calculated from these variables (apparently...)
    function addPolygonAndMarkerForPhotodiode(obj, x_L, x_C, x_R, photoDiodeSquareON)    
%       [x_L, x_C, x_R]
      
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
      
      plot(p, 'FaceColor', rbg, 'FaceAlpha', 1.0); hold on
      
      
      if( photoDiodeSquareON )
        % draw square for the photodiode to detect
        PIXEL_WIDTH_OF_PHOTODIODE_SIGNAL = 150;
        
        % calculate all of the coordinates of the polygon to project (see
        % paper drawing)
        top_left_x = - (obj.ScreenWidth / 2) ;
        top_left_y = - (obj.ScreenHeight / 2) + PIXEL_WIDTH_OF_PHOTODIODE_SIGNAL;
        top_right_x = - (obj.ScreenWidth / 2) + PIXEL_WIDTH_OF_PHOTODIODE_SIGNAL ;
        top_right_y = - (obj.ScreenHeight / 2) + PIXEL_WIDTH_OF_PHOTODIODE_SIGNAL;
        bottom_right_x = - (obj.ScreenWidth / 2) + PIXEL_WIDTH_OF_PHOTODIODE_SIGNAL;
        bottom_right_y = - (obj.ScreenHeight / 2) ;
        bottom_left_x = - (obj.ScreenWidth / 2);
        bottom_left_y = - (obj.ScreenHeight / 2) ;
        
        % plot the polygon of the photodiode signal
        X = [top_left_x, top_right_x, bottom_right_x, bottom_left_x];
        Y = [top_left_y, top_right_y, bottom_right_y, bottom_left_y];
        p = polyshape(X, Y);
        rbg = [0 0 0];
      
        plot(p, 'FaceColor', rbg, 'FaceAlpha', 1.0)           
      end
      
      % set the figure width & height to match that for the video
      w = obj.ScreenWidth / 2;
      h = obj.ScreenHeight / 2;
      xlim([-w w])
      ylim([-h h])
      
      set(gcf,'Position',[0 0 obj.ScreenWidth obj.ScreenHeight])
      set(gca,'Position',[0 0 1 1], 'units', 'normalized')
      set(gca, 'box', 'off', 'XTickLabel', [], 'xtick', [], 'YTickLabel', [], 'ytick', [])
      set(gca, 'visible', 'off')
      
      % remove extra margin
%       ax = gca;
%       outerpos = ax.OuterPosition;
%       ti = ax.TightInset; 
%       left = outerpos(1) + ti(1);
%       bottom = outerpos(2) + ti(2);
%       ax_width = outerpos(3) - ti(1) - ti(3);
%       ax_height = outerpos(4) - ti(2) - ti(4);
%       ax.Position = [left bottom ax_width ax_height];
%       
      
      % capture frame, save to video
      F = getframe(obj.FigureHandle);
      obj.addFrame(F)
      
      hold off; % allow things to be draw over for the next frame
    end
    
    % adds a FRAME struct to the current video
    function addFrame(self, frame)
      %  The height and width must be  consistent for all frames within a file.
      writeVideo(self.VideoObj, frame)
    end
    
    function saveVideo(self)
      close(self.VideoObj)
    end
  end
  
  % Class Methods
  methods (Static)
    function [L] = default(outfile)
      IPAD_WIDTH = 2388;
      IPAD_HEIGHT = 1668;
      L = LoomCreator(IPAD_WIDTH, IPAD_HEIGHT, outfile);
    end
  end
end

