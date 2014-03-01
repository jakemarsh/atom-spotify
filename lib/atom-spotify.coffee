AtomSpotifyStatusBarView = require './atom-spotify-status-bar-view'

module.exports =
  activate: ->
    @atomSpotifyStatusBarView = new AtomSpotifyStatusBarView()
