ready = ->
  $('#driver_birthday').datepicker({
    changeMonth:true,
    changeYear:true,
    yearRange:"-65:-16"
  });
$(document).ready(ready)
$(document).on('page:load', ready)