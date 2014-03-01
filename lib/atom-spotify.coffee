AtomSpotifyStatusBarView = require './atom-spotify-status-bar-view'

module.exports =
  activate: (state) ->
    @atomSpotifyStatusBarView = new AtomSpotifyStatusBarView()
