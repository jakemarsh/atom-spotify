spotify = require 'spotify-node-applescript'

Number::times = (fn) ->
  do fn for [1..@valueOf()] if @valueOf()
  return

class AtomSpotifyStatusBarView extends HTMLElement
  initialize: () ->
    @classList.add('spotify', 'inline-block')

    div = document.createElement('div')
    div.classList.add('spotify-container')

    @soundBars = document.createElement('span')
    @soundBars.classList.add('spotify-sound-bars')
    @soundBars.data = {
      hidden: true,
      state: 'paused'
    }

    5.times =>
      soundBar = document.createElement('span')
      soundBar.classList.add('spotify-sound-bar')
      @soundBars.appendChild(soundBar)

    div.appendChild(@soundBars)

    @trackInfo = document.createElement('span')
    @trackInfo.classList.add('track-info')
    @trackInfo.textContent = ''
    div.appendChild(@trackInfo)

    @appendChild(div)

    atom.commands.add 'atom-workspace', 'atom-spotify:next', => spotify.next => @updateTrackInfo()
    atom.commands.add 'atom-workspace', 'atom-spotify:previous', => spotify.previous => @updateTrackInfo()
    atom.commands.add 'atom-workspace', 'atom-spotify:play', => spotify.play => @updateTrackInfo()
    atom.commands.add 'atom-workspace', 'atom-spotify:pause', => spotify.pause => @updateTrackInfo()
    atom.commands.add 'atom-workspace', 'atom-spotify:togglePlay', => @togglePlay()

    atom.config.observe 'atom-spotify.showEqualizer', (newValue) =>
      @toggleShowEqualizer(newValue)

    setInterval =>
      @updateTrackInfo()
    , 5000

  updateTrackInfo: () ->
    spotify.isRunning (err, isRunning) =>
      if isRunning
        spotify.getState (err, state)=>
          if state
            spotify.getTrack (error, track) =>
              if track
                trackInfoText = ""
                if atom.config.get('atom-spotify.showPlayStatus')
                  if !atom.config.get('atom-spotify.showPlayIconAsText')
                    trackInfoText = if state.state == 'playing' then '► ' else '|| '
                  else
                    trackInfoText = if state.state == 'playing' then 'Now Playing: ' else 'Paused: '
                trackInfoText += "#{track.artist} - #{track.name}"

                if !atom.config.get('atom-spotify.showEqualizer')
                  if atom.config.get('atom-spotify.showPlayStatus')
                    trackInfoText += " ♫"
                  else
                    trackInfoText = "♫ " + trackInfoText

                @trackInfo.textContent = trackInfoText
              else
                @trackInfo.textContent = ''
              @updateEqualizer()
      else # spotify isn't running, hide the sound bars!
        @trackInfo.textContent = ''


  updateEqualizer: ()->
    spotify.isRunning (err, isRunning)=>
      spotify.getState (err, state)=>
        return if err
        @togglePauseEqualizer state.state isnt 'playing'

  togglePlay: ()->
    spotify.isRunning (err, isRunning) =>
      if isRunning
        spotify.playPause =>
          @updateEqualizer()

  toggleShowEqualizer: (shown) ->
    if shown
      @soundBars.removeAttribute 'data-hidden'
    else
      @soundBars.setAttribute 'data-hidden', true

  togglePauseEqualizer: (paused) ->
    if paused
      @soundBars.setAttribute 'data-state', 'paused'
    else
      @soundBars.removeAttribute 'data-state'

module.exports = document.registerElement('status-bar-spotify',
                                          prototype: AtomSpotifyStatusBarView.prototype,
                                          extends: 'div')
















# module.exports =
# class AtomSpotifyStatusBarView extends View
#   @content: ->
#     @div class: 'spotify inline-block', =>
#       @div outlet: 'container', class: 'spotify-container', =>
#         @span outlet: 'soundBars', 'data-hidden': true, 'data-state': 'paused', class: 'spotify-sound-bars', =>
#           @span class: 'spotify-sound-bar'
#           @span class: 'spotify-sound-bar'
#           @span class: 'spotify-sound-bar'
#           @span class: 'spotify-sound-bar'
#           @span class: 'spotify-sound-bar'
#         @span outlet: "trackInfo", class: 'atom-spotify-status', tabindex: '-1', ""
