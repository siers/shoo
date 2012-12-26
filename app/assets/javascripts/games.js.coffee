google.load('jquery', '1');

onLoad = ->
  $.log = ->
    if window.console
      console.log.apply(console, arguments)

  Game.show() if $('body').is('.games.show')

google.setOnLoadCallback ->
  try
    $ onLoad
  catch e
    $.log(e)

Console =
  lines:  []
  height: 15
  elem:   -> @elem = $("#footer #console")
  input:  ->
    @input = input = $("#footer form input").val('')
    $("#footer form").submit (e) ->
      e.preventDefault()
      Dispacher.send {type: 'chat', msg: val = input.val()}
      Console.write(val)
      input.val('')

  init: ->
    @elem()
    @input()
    Dispacher.route 'chat', (data) ->
      Console.write(data['msg'])
    Dispacher.sock.bind 'console.puts', (msg) ->
      Console.put(msg)

  add: (line) ->
    @lines.unshift(line)
    @lines.pop() if @lines.count > @height
    @elem.text(@lines.join("\n"))

  write: (text...) ->
    @add(text.join(' '))

  err: (text...) -> @write('!!!', text...)
  log: (text...) -> @write('<--', text...)
  put: (text...) -> @write('-->', text...)

Dispacher =
  sock: new WebSocketRails('localhost:3000/websocket')

  router: { null: 'place events in me!' } # Routes only game.ctcp.
  route: (event, handler) -> @router[event] = handler

  recv: (data) ->
    handler = Dispacher.router[data.type]
    return Console.err("Unrouted event: #{ data.type || 'no-type-set' }.") unless handler
    handler(data)

  send: (data) ->
    @sock.trigger('game.ctcp', data)

  init: ->
    #@sock.trigger('websocket_rails.reload!')
    @sock.bind 'game.ctcp', @recv

window.Game =
  list:       {}
  field:      -> $("#space")
  console:    Console
  dispacher:  Dispacher

  sock: ->
    @sock = Dispacher.sock

  name: ->
    @name = window.location.href.split('/').pop()

  current: ->
    @current = @list[@name()]

  new: ->
    @current.init(@field())
    @sock.trigger('game.new', {type: @name})

  events: ->
    @sock.bind 'game.connected', ->
      Console.log "Ready!"
      Game.current.start()
    @sock.bind 'game.reset', ->
      Console.log "Other player(s) disconnected."
      Game.current.stop()

  show: ->
    Console.init()
    Dispacher.init()
    @current()
    @sock()
    @events()
    @new()
