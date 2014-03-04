{View} = require 'atom'
spotify = require 'spotify-node-applescript'

module.exports =
class AtomSpotifyStatusBarView extends View
  @content: ->
    @div class: 'inline-block', =>
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
      setTimeout =>
        atom.workspaceView.statusBar.appendLeft(this)
      , 1

  updateTrackInfo: ->
    spotify.getTrack (error, track) =>
      @trackInfo.text("♫ #{track.artist} - #{track.name}") if track

  afterAttach: ->
    setInterval =>
      @updateTrackInfo()
    , 1000
