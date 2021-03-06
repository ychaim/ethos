try
	#global.winston.info( 'Ethos Node-Webkit: Bootstraping Ξthos...', process, global )

	_ = require 'underscore'
	querystring = require 'querystring'

	process.on "uncaughtException", (err) -> 
		#global.winston.error( "Ethos Node-Webkit: Uncaught Exception.", err)
		alert("error: " + err)

	if global?
		try
			gui = require('nw.gui')
		catch err
			console.log( "Error: ", err )

		app = gui.App

		# Attach event bus / vent to global object using EventEmitter
		EventEmitter = require( 'events' )	
		global.vent = new EventEmitter()

		# Get the bootstrap window (this one) and hide it.
		win = gui.Window.get()	
		win.showDevTools()
		win.hide()


		# Create a new main window for app content.
		mainWindowOptions =
			show: true
			toolbar: true
			frame: true
			icon: "./app/images/ethos-logo.png"
			"inject-js-start": "./app/scripts/inject.bundle.js"
			position: "center"
			width: 1024
			height: 768
			min_width: 300
			min_height: 200
		
		mainWindow = gui.Window.open( 'http://eth:8080/', mainWindowOptions )
		mainwin = gui.Window.get( mainWindow )
		
		mb = new gui.Menu( type:"menubar" )
		#mb.append(new gui.MenuItem({ label: 'Item A' }))

		tray = new gui.Tray({ title: 'Tray', icon: './app/images/ethos-logo.png' });

		mb.createMacBuiltin?( "Ethos" )
		mainwin.menu = mb

		mainwin.onerror = -> alert('err')
		mainWindow.on 'close', ->
			win.close()

		dialogwin = dialogWindow = null

		global.showDialog = (data = {}) ->
			# Create a new dialog window for notifications
			defaultDialogWindowOptions =
				url: 'http://eth:8080/ethos/dialog'
				frame: false
				toolbar: false
				resizable: false
				width: 400
				height: 200
				query: {}
			dialogWindowOptions = _.defaults( data, defaultDialogWindowOptions )
			url = "#{ dialogWindowOptions.url }?#{ querystring.stringify( dialogWindowOptions.query ) }"
			global.winston.info "Ethos Node-Webkit: Show Dialog window. ", url
			dialogWindow = gui.Window.open( url, dialogWindowOptions )
			dialogwin = gui.Window.get( dialogWindow )
			dialogWindow.focus()

		global.showGlobalDev = ->
			global.winston.info "Ethos Node-Webkit: showGlobalDev requested."
			win.showDevTools()

	global?.winston.info( 'Ethos Node-Webkit: Ξthos Bootstrap end: ok.' )
catch bootstrapError
	alert( 'Bootstrap Error' )