ready = -> 
  
  # setup the faye javascript client
  window.league_id = document.URL.split("/")[4]
  console.log(league_id)
  client = new Faye.Client('/faye')
  
  # the knockoutjs view model
  class DraftViewModel
    constructor: ->
      @current_player = ko.observable("No Player")
      @bid = ko.observable(0)
      @current_bid = ko.computed (-> "$#{@bid()}"), this
      @current_team = ko.observable("No Team")
      @start_bid = ko.computed ( -> parseInt(@bid()) + 1), this
      
      @seconds = ko.observable(10)
      @seconds_format = ko.computed ( -> "Time: #{@seconds()}"), this
      
      @timer_end = ko.computed ( ->
        if @seconds() == 0
          clearInterval(timer)
      ), this
  
  viewModel = new DraftViewModel()
  ko.applyBindings(viewModel)
  
  timer = setInterval ( -> viewModel.seconds(viewModel.seconds() - 1) ), 1000
  
  set_timer = (sec) ->
    message = 
      type: 'time'
      seconds: sec
      
    client.publish("/draft#{league_id}", message)
  
  client.subscribe("/draft#{league_id}", (message) -> 
    if message.type == 'nominate'
      viewModel.current_player(message.player)
      viewModel.bid(1)
      viewModel.current_team("to #{message.team}")
    else if message.type == 'bid'
      viewModel.bid(message.bid)
      viewModel.current_team("to #{message.team}")
    else if message.type == 'time'
      viewModel.seconds(message.seconds)
  )

  $("a.nominate").click( (event) ->
    event.preventDefault()
    set_timer(10) # reset timer to 10 seconds
    playerRow = $(event.currentTarget).parent().siblings()
    playerData = 
      type:    'nominate'
      player:  $(playerRow[0]).children().text()
      country: playerRow[1].innerHTML
      rank:    playerRow[2].innerHTML
      team:    $("#team_name").text()
      
    client.publish("/draft#{window.league_id}", playerData)
  )
  
  $("#bid").click( (event) ->
    event.preventDefault()
    set_timer(10)
    
    input = $("input")
    if input[0].checkValidity()
      bid = input.val()
      data = 
        type: 'bid'
        bid: bid
        team: $("#team_name").text()
      
      client.publish("/draft#{league_id}", data)
    else
      alert("Cannot bid lower than current bid")
  )

$ -> ready()