AtomSpotifyStatusBarView = require './atom-spotify-status-bar-view'

module.exports =
  config:
    displayOnLeftSide:
        type: 'boolean'
        default: true
    showEqualizer:
        type: 'boolean'
        default: false
    showPlayStatus:
        type: 'boolean'
        default: true
    showPlayIconAsText:
        type: 'boolean'
        default: false

  activate: ->
    atom.packages.onDidActivateInitialPackages ->
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
