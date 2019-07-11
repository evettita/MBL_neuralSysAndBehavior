% createLoom

function createLoom(X_L, X_C, X_R, file_name)
  IPAD_WIDTH = 1920;
  IPAD_HEIGHT = 1080;
  l = LoomCreator(IPAD_WIDTH, IPAD_HEIGHT, file_name);
  l.addCoordinateVectors(X_L, X_C, X_R)
  l.saveVideo();
end
