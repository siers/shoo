Game.list['dummy'] = Dummy =
  init: (field) ->
    @field = $(field)
    @add_button()
    Game.console.log "Game init."
    Game.dispacher.route 'dummy.click', ->
      Dummy.click()

  click: ->
    Dummy.rot += 10
    rot = "rotate(#{ Dummy.rot }deg)"
    Dummy.btn.css {
      'transform'         : rot,
      '-ms-transform'     : rot,
      '-moz-transform'    : rot,
      '-webkit-transform' : rot,
      '-o-transform'      : rot,
    }

  add_button: ->
    style = 'position: absolute; top: 50%; left: 50%; margin: -5px 0 0 -10px;'
    @btn = $("<button style='#{ style }' disabled='disabled'>click me</button>").
      appendTo(@field).
      bind 'click', ->
        Dummy.click()
        Game.dispacher.send {type: 'dummy.click'}

  start: ->
    @rot = -10
    @click()
    @btn.prop('disabled', 0)
    Game.console.log "Game's running!"

  stop: ->
    @btn.prop('disabled', 1)
    Game.console.log "Game stopped."
