{View} = require 'atom'
spotify = require 'spotify-node-applescript'

module.exports =
class AtomSpotifyStatusBarView extends View
  @content: ->
    @div class: 'spotify inline-block', =>
      @div outlet: 'container', class: 'spotify-container', =>
        @span outlet: 'soundBars', class: 'spotify-sound-bars', =>
          @span class: 'spotify-sound-bar'
          @span class: 'spotify-sound-bar'
          @span class: 'spotify-sound-bar'
          @span class: 'spotify-sound-bar'
          @span class: 'spotify-sound-bar'
        @span outlet: "trackInfo", class: 'atom-spotify-status', tabindex: '-1', ""

  initialize: ->
    atom.workspaceView.command 'atom-spotify:next', => spotify.next => @updateTrackInfo()
    atom.workspaceView.command 'atom-spotify:previous', => spotify.previous => @updateTrackInfo()

    # We wait until all the other packages have been loaded,
    # so all the other status bar views have been attached
    @subscribe atom.packages.once 'activated', =>
      # We use an ugly setTimeout here to make sure our view gets
      # added as the "last" (farthest right) item in the
      # left side of the status bar

      if !atom.config.get('atom-spotify.showEqualizer')
        @soundBars.attr('data-hidden', true)

      setTimeout =>
        if atom.config.get('atom-spotify.displayOnLeftSide')
          atom.workspaceView.statusBar.appendLeft(this)
        else
          atom.workspaceView.statusBar.appendRight(this)
      , 1

  updateTrackInfo: (bars) ->
    spotify.isRunning (err, isRunning) =>
      if isRunning
        spotify.getTrack (error, track) =>
          trackInfoText = "#{track.artist} - #{track.name}"
          if !atom.config.get('atom-spotify.showEqualizer')
            trackInfoText = "♫ " + trackInfoText
          if track
            @trackInfo.text(trackInfoText)
            if atom.config.get('atom-spotify.showEqualizer')
              bars.attr('data-hidden', false)
          else
            @trackInfo.text('')
            if atom.config.get('atom-spotify.showEqualizer')
              bars.attr('data-hidden', true)
      else # spotify isn't running, hide the sound bars!
        @trackInfo.text('')
        bars.attr('data-hidden', true)

  afterAttach: ->
    setInterval =>
      @updateTrackInfo(@soundBars)
    , 1000
