https://cdn.dribbble.com/users/1062923/screenshots/2981759/weather_dribbble.gif
  This seems like a pretty cool raining animation I wonder how hard it would be to integrate into an app. 

https://www.love2d.org/forums/viewtopic.php?p=229072
  How to make text scroll

main.lua

core/
  app.lua
  scene_manager.lua

scenes/
  menu_scene.lua
  loading_scene.lua
  weather_scene.lua
  error_scene.lua

ui/
  base_element.lua
  button.lua
  label.lua
  scrolling_text.lua
  panel.lua
  animated_sprite.lua

animation/
  animator.lua
  tween.lua
  easing.lua

services/
  weather_service.lua
  api_client.lua
  parser.lua

domain/
  weather_report.lua
  city.lua

atmosphere/
  atmosphere_controller.lua
  particles.lua

themes/
  pastel_theme.lua

assets/
  fonts/
  sprites/
  sounds/
