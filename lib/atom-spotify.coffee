AtomSpotifyStatusBarView = require './atom-spotify-status-bar-view'

module.exports =

  configDefaults:
    displayOnLeftSide: true
    showEqualizer: false
    showPlayStatus: true;
    showPlayIconAsText: false;

  activate: ->
    @atomSpotifyStatusBarView = new AtomSpotifyStatusBarView()
