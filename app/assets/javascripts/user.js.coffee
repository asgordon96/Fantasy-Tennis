# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

close_flash = -> $('.alert').slideUp(500, -> $(this).remove)
$('a.close').bind('click', close_flash)
window.setTimeout(close_flash, 5000)