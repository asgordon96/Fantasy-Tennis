ready = -> 
  
  # setup the faye javascript client
  window.league_id = document.URL.split("/")[4]
  client = new Faye.Client('/faye')
  
  set_timer = (sec) ->
    message = 
      id: league_id
      type: 'time'
      seconds: sec
      
    client.publish("/draft#{league_id}", message)
  
  # the knockoutjs view model
  class DraftViewModel
    constructor: ->
      @current_player = ko.observable("No Player")
      @bid = ko.observable(0)
      @current_bid = ko.computed (-> "$#{@bid()}"), this
      @current_team = ko.observable("No Team")
      @start_bid = ko.computed ( -> parseInt(@bid()) + 1), this
      @nominator = ko.observable("")
      
      @money = ko.observable(200)
      @money_format = ko.computed ( ->
        "Remaining: $#{@money()}"
      ), this
      @get_remaining()
      
      @set_remaining = ko.computed ( ->
        localStorage["money_left"] = @money() 
      ), this
      
      @seconds = ko.observable(10)
      @seconds_format = ko.computed ( -> "Time: #{@seconds()}"), this
      
      @timer_end = ko.computed ( ->
        if @seconds() == 0
          clearInterval(timer)
          if @bid() == 0 # ran out of nomination time
            $("a.nominate").first().trigger("click")
          
          if @current_team() == $("#team_name").text() # if this team won the player
            @money(@money() - @bid())
            data = { player: @current_player(), team: @current_team() }
            $.post("/leagues/#{league_id}/draft/buyplayer", data, @get_team)
            set_timer(30)
            
      ), this
      
      @can_bid = ko.computed ( ->
        if @current_team() == $("#team_name").text()
          false
        else
          true
      ), this
    
    get_team: ->
      $("#myteam").load("/leagues/#{league_id}/draft/myteam")
      client.publish("/draft#{league_id}", { id: league_id, type: "reload players" })
    
    # get remaining money fro local storage
    get_remaining: -> 
      if (localStorage["money_left"])
        @money(localStorage["money_left"])
      else
        @money(200)
        localStorage["money_left"] = 200
        
    hide_nominate: =>
      console.log("HERE")
      console.log(@nominator())
      if $("#team_name").text() != @nominator() or @bid() > 0 # we're not nominating, or biddin is in progress
        $("a.nominate").hide()
      else
        $("a.nominate").show()
      
    
  window.viewModel = new DraftViewModel()
  ko.applyBindings(viewModel)
  
  timer = setInterval ( -> viewModel.seconds(viewModel.seconds() - 1) ), 1000
  
  client.subscribe("/draft#{league_id}", (message) -> 
    if message.type == 'nominate'
      viewModel.current_player(message.player)
      viewModel.bid(1)
      viewModel.current_team(message.team)
    else if message.type == 'bid'
      viewModel.bid(message.bid)
      viewModel.current_team(message.team)
    else if message.type == 'time'
      viewModel.seconds(message.seconds)
      clearInterval(timer)
      timer = setInterval ( -> viewModel.seconds(viewModel.seconds() - 1)), 1000
    
    else if message.type == 'reload players'
      $("#available").load("/leagues/#{league_id}/draft/available", ->
        $.get("/leagues/#{league_id}/draft/nominator", (data) ->
          console.log(data)
          viewModel.nominator(data.nominator)
          viewModel.hide_nominate()
        )
      )
      viewModel.current_player("Waiting for nomination...")
      viewModel.current_team("")
      viewModel.bid(0)
    
    else if message.type == 'nominator'
      console.log(message)
      viewModel.nominator(message.team)
  )
  
  $(document).on('click', 'a.nominate', (event) ->
    event.preventDefault()
    set_timer(10) # reset timer to 30 seconds
    playerRow = $(event.currentTarget).parent().siblings()
    playerData = 
      id: league_id
      type:    'nominate'
      player:  $(playerRow[0]).children().text()
      country: playerRow[1].innerHTML
      rank:    playerRow[2].innerHTML
      team:    $("#team_name").text()
  
    client.publish("/draft#{window.league_id}", playerData)
    viewModel.nominator("")
    viewModel.hide_nominate()
  )
  
  $("#bid").click( (event) ->
    event.preventDefault()
    
    input = $("input")
    if input[0].checkValidity()
      bid = input.val()
      if viewModel.seconds() < 10
        set_timer(10)
        
      data = 
        id: league_id
        type: 'bid'
        bid: bid
        team: $("#team_name").text()
      
      client.publish("/draft#{league_id}", data)
    else
      apprise("Invalid Bid. Cannot bid lower than current bid or higher than amount of money left")
  )

$(ready)
document.addEventListener("page:load", ready)