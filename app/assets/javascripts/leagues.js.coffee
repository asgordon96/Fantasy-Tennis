# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  now = new Date().toISOString().split("T")[0]
  $("#draft_day").val(now)
  
  if location.href.indexOf("available") != -1
    $(".add").show()

$(document).ready(ready)
document.addEventListener("page:load", ready)