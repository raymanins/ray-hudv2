fx_version 'cerulean'
game 'gta5'

author 'raymans'
description 'HUD for QBCore/Qbox Framework'
version '2.0.0'
lua54 'yes'

shared_script '@ox_lib/init.lua'

client_scripts {
    'main.lua',
    'minimap.lua'
}

dependencies {
    'qb-core'
}

ui_page 'ui.html'

files {
    'ui.html',
    'styles.css',
    'script.js'
}
