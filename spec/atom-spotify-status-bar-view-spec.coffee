AtomSpotifyStatusBarView = require '../lib/atom-spotify-status-bar-view'
{WorkspaceView} = require 'atom'

describe "AtomSpotifyStatusBarView", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView

    waitsForPromise ->
      atom.packages.activatePackage('atom-spotify')

  describe "when rocking out", ->
    it "renders the current song's info", ->
      runs ->
        statusBar = atom.workspaceView.statusBar
        setTimeout =>
          expect(statusBar.find('a.atom-spotify-status').text()).toBe ''
        , 500
