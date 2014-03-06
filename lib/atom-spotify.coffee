AtomSpotifyStatusBarView = require './atom-spotify-status-bar-view'

module.exports =

  configDefaults:
    displayOnLeftSide: true
    showEqualizer: false

  activate: ->
    @atomSpotifyStatusBarView = new AtomSpotifyStatusBarView()
