--[[ FX Information ]]--
fx_version   'adamant'
game         'gta5'

--[[ Resource Information ]]--
name         'NORP Fleeca'
author       'Judd#7644'
version      '1.0.0'
repository   'https://github.com/nightowlsrp/norp-fleeca'
description  'Fleeca Robberies'

--[[ Manifest ]]--
dependencies {
	'es_extended',
	'PolyZone',
	'qtarget',
	'ox_inventory'
}

shared_scripts {
	'shared/*.lua',
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}