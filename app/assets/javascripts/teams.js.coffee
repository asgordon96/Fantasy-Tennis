ready = ->
  $("#dropbutton").click (event) ->
    event.preventDefault()
    $(".drop").toggle()
    btn = $("#dropbutton")
    if btn.text() == "Done"
      btn.text("Drop Players")
    else
      btn.text("Done")
  
  $(".drop").click (event) ->
    event.preventDefault()
    console.log("Here")
    apprise('Are you sure you want to drop this player?', {'verify': true}, (confirm) ->
      if confirm
        player_id = event.target.id
        url = location.href + "/drop"
        data = { player_id: player_id }
        $.post(url, data)
    
        $(event.target).parent().parent().remove()
    )
  
  
$(ready)
document.addEventListener("page:load", ready)