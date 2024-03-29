
--Start of Global Scope---------------------------------------------------------

Script.serveEvent('CombineFilters3D.OnMessage1', 'OnMessage1')
Script.serveEvent('CombineFilters3D.OnMessage2', 'OnMessage2')

-- Create viewer for original and filtered 3D image

local viewer1 = View.create('viewer3D1') -- Will show in 3D viewer
local viewer2 = View.create('viewer3D2') -- Will show in 3D viewer
local imDeco = View.ImageDecoration.create()
imDeco:setRange(36, 157)

--End of Global Scope-----------------------------------------------------------

-- Start of Function and Event Scope--------------------------------------------

--@filteringImage(heightMap:Image, intensityMap:Image)
local function filteringImage(heightMap, intensityMap)
  -- COMBINE FILTERS: This is an example using first median filter and then gauss filter

  -- Filter on the heightMap
  local kernelsize = 9 -- Size of the kernel, must be positive and odd
  local medianImage = heightMap:median(kernelsize) -- Median filtering
  local medianIntensityMap = intensityMap:median(kernelsize)

  -- Visualize the input (median image)
  viewer1:clear()
  viewer1:addHeightmap({medianImage, medianIntensityMap}, imDeco, {'Reflectance'}) -- Add the current filtered heightMap
  viewer1:present()

  Script.notifyEvent('OnMessage1', 'Original image')

  -- Filter on the medianImage
  local kernelsize2 = 7 -- Size of the kernel, must be positive and odd
  local gaussImage = medianImage:gauss(kernelsize2) -- Gauss filtering
  local gaussIntensityMap = medianIntensityMap:gauss(kernelsize2)

  -- Visualize the output (median + gauss image)
  viewer2:clear()
  -- Add the second current filtered heightMap
  viewer2:addHeightmap({gaussImage, gaussIntensityMap}, imDeco, {'Reflectance'})
  viewer2:present()

  Script.notifyEvent('OnMessage2', 'Median filter, kernel size: ' ..
                     kernelsize .. '. Gauss filter, kernel size: ' .. kernelsize2)
end

local function main()
  -- Load a json-image
  local data = Object.load('resources/image_23.json')

  -- Extract heightmap, intensity map and sensor data
  local heightMap = data[1]
  local intensityMap = data[2]
  local sensorData = data[3] --luacheck: ignore

  -- Filter image
  filteringImage(heightMap, intensityMap)

  print('App finished')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
