{View} = require 'atom'
spotify = require 'spotify-node-applescript'

module.exports =
class AtomSpotifyStatusBarView extends View
  @content: ->
    @div class: 'spotify inline-block', =>
      @div outlet: 'container', class: 'spotify-container', =>
        @span outlet: 'soundBars', 'data-hidden': true, 'data-state': 'paused', class: 'spotify-sound-bars', =>
          @span class: 'spotify-sound-bar'
          @span class: 'spotify-sound-bar'
          @span class: 'spotify-sound-bar'
          @span class: 'spotify-sound-bar'
          @span class: 'spotify-sound-bar'
        @span outlet: "trackInfo", class: 'atom-spotify-status', tabindex: '-1', ""

  initialize: ->
    atom.workspaceView.command 'atom-spotify:next', => spotify.next => @updateTrackInfo()
    atom.workspaceView.command 'atom-spotify:previous', => spotify.previous => @updateTrackInfo()
    atom.workspaceView.command 'atom-spotify:play', => spotify.play => @updateTrackInfo()
    atom.workspaceView.command 'atom-spotify:pause', => spotify.pause => @updateTrackInfo()
    atom.workspaceView.command 'atom-spotify:togglePlay', => @togglePlay()


    @on 'click', => @togglePlay()

    # We wait until all the other packages have been loaded,
    # so all the other status bar views have been attached
    @subscribe atom.packages.once 'activated', =>
      # We use an ugly setTimeout here to make sure our view gets
      # added as the "last" (farthest right) item in the
      # left side of the status bar

      atom.config.observe 'atom-spotify.showEqualizer', =>
        @toggleShowEqualizer atom.config.get('atom-spotify.showEqualizer')

      atom.config.observe 'atom-spotify.displayOnLeftSide', =>
        setTimeout =>
          @appendToStatusBar atom.config.get('atom-spotify.displayOnLeftSide')
        , 1

  toggleShowEqualizer: (shown)->
    if shown
      @soundBars.removeAttr 'data-hidden'
    else
      @soundBars.attr 'data-hidden', true

  togglePauseEqualizer: (paused)->
    if paused
      @soundBars.attr 'data-state', 'paused'
    else
      @soundBars.removeAttr 'data-state'

  appendToStatusBar: (onLeftSide)->
    this.detach()

    if onLeftSide
      atom.workspaceView.statusBar.appendLeft(this)
    else
      atom.workspaceView.statusBar.appendRight(this)

  updateTrackInfo: () ->
    spotify.isRunning (err, isRunning) =>
      if isRunning
        spotify.getTrack (error, track) =>
          if track
            trackInfoText = "#{track.artist} - #{track.name}"

            if !atom.config.get('atom-spotify.showEqualizer')
              trackInfoText = "♫ " + trackInfoText

            @trackInfo.text trackInfoText
          else
            @trackInfo.text('')
          @updateEqualizer()
      else # spotify isn't running, hide the sound bars!
        @trackInfo.text('')

  updateEqualizer: ()->
    spotify.isRunning (err, isRunning)=>
      spotify.getState (err, state)=>
        return if err
        @togglePauseEqualizer state.state isnt 'playing'

  togglePlay: ()->
    spotify.isRunning (err, isRunning) =>
      if isRunning
        spotify.playPause =>
          @updateEqualizer()


  afterAttach: ->
    setInterval =>
      @updateTrackInfo()
    , 1000
