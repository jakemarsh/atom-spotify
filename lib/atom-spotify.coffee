AtomSpotifyStatusBarView = require './atom-spotify-status-bar-view'

module.exports =
  configDefaults:
    displayOnLeftSide: true
    showEqualizer: false
    showPlayStatus: true
    showPlayIconAsText: false

  activate: ->
    atom.packages.once 'activated', =>
      @statusBar = document.querySelector('status-bar')

      @spotifyView = new AtomSpotifyStatusBarView()

      @spotifyView.initialize()

      if atom.config.get('atom-spotify.displayOnLeftSide')
        @statusBar.addLeftTile(item: @spotifyView, priority: 100)
      else
        @statusBar.addRightTile(item: @spotifyView, priority: 100)

  deactivate: ->
    @spotifyView?.destroy()
    @spotifyView = null
