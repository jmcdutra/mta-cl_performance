local screen = Vector2(guiGetScreenSize())
local tx, ty = ( screen.x / 1920 ), ( screen.y / 1080 )

local fontTypes = {
    ['Regular'] = "assets/fonts/os-regular.ttf",
    ['Medium'] = "assets/fonts/os-medium.ttf",
    ['Semibold'] = "assets/fonts/os-semibold.ttf",
}

local defaultFont = "default-bold"

local cachedFonts = {}

FONTS = {
    deleteAllFonts = function()

        for _, cachedFont in pairs( cachedFonts ) do
            for _, font in pairs( cachedFont.data ) do
                destroyElement( font )
            end
        end

        cachedFonts = {}
    end
}

-- Metatable
setmetatable( FONTS, {
    __index = function( self, key )
        if type(key) ~= "number" then return nil end

        if type(cachedFonts[ key ]) == "nil" then
            cachedFonts[ key ] = { size = key, data = {} }
            setmetatable( cachedFonts[ key ], {
                __index = function( font, fontkey )
                    local fontType = fontTypes[ fontkey ]
                    if type(fontType) == "string" then
                        if type(font.data[ fontType ]) == "nil" then
                            font.data[ fontType ] = dxCreateFont( fontType, ty * font.size ) or defaultFont
                        end
                        return font.data[ fontType ]
                    else
                        return nil
                    end
                end,
            } )

        end
        return cachedFonts[ key ]

    end,

} )