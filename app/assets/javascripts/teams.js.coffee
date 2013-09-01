ready = ->
  $("#dropbutton").click (event) ->
    event.preventDefault()
    $(".drop").toggle()
    btn = $("#dropbutton")
    if btn.text() == "Done"
      btn.text("Drop Players")
    else
      btn.text("Done")
  
  $(document).on("click", ".drop", (event) ->
    event.preventDefault()
    player_id = event.target.id
    console.log(player_id)
    $(event.target).parent().parent().remove()
  )
  
  
$(ready)
$(document).addEventListener("page:load", ready)