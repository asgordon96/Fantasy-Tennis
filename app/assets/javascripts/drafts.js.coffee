ready = -> 
  
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
  
  viewModel = new DraftViewModel()
  ko.applyBindings(viewModel)
  
  client.subscribe("/draft#{league_id}", (message) -> 
    if message.type == 'nominate'
      viewModel.current_player(message.player)
      viewModel.bid(1)
    else if message.type = 'bid'
      viewModel.bid(message.bid)
  )

  $("a.nominate").click( (event) ->
    event.preventDefault()
    playerRow = $(event.currentTarget).parent().siblings()
    playerData = 
      type:    'nominate'
      player:  playerRow[0].innerHTML
      country: playerRow[1].innerHTML
      rank:    playerRow[2].innerHTML
    client.publish("/draft#{window.league_id}", playerData)
  )
  
  $("#bid").click( (event) ->
    event.preventDefault()
    bid = $("input").val()
    data = 
      type: 'bid'
      bid: bid
      
    client.publish("/draft#{league_id}", data)
  )

$ -> ready()