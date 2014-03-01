{View} = require 'atom'

spotify = require 'spotify-node-applescript'

module.exports =
class AtomSpotifyStatusBarView extends View
  @content: ->
    @div class: 'inline-block', =>
      @span outlet: "trackInfo", class: 'atom-spotify-status', tabindex: '-1', ""

  initialize: ->
    @subscribe atom.packages.once 'activated', =>
      # We use an ugly setTimeout here to make sure our view gets
      # added as the "last" (farthest right) item in the
      # left side of the status bar
      setTimeout =>
        atom.workspaceView.statusBar.appendLeft(this)
      , 1

  afterAttach: ->
    setInterval =>
      spotify.getTrack (err, track) =>
        @trackInfo.text("♫ #{track.artist} - #{track.name}")
    , 1000
