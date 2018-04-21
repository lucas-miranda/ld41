export class Grid extends Entity
    new: =>
        super!

        @rows = 0
        @columns = 0

        -- cell
        @cell = width: 0, height: 0
        @cells = {}
        @gridCellGraphic = love.graphics.newImage("content/graphics/cell.png")
        @gridCellQuad = love.graphics.newQuad(0, 0, 16, 16, @gridCellGraphic\getDimensions!)

        -- layers
        @tilesets = {}
        @layers = {}

        -- entities
        @entities = {} -- for reference only

    update: (dt) =>
        super(dt)

    draw: =>
        super!
        if (@rows == 0 or @columns == 0)
            return

        -- layers
        for i, layer in pairs @layers
            layer\draw!

        -- cells
        love.graphics.setColor(0, 0, 0, 0)
        @gridCellQuad\setViewport(0, 0, @cell.width, @cell.height)
        for y = 1, @rows - 1
            for x = 1, @columns - 1
                pos = x: (x - 1) * @cell.width, y: (y - 1) * @cell.height
                love.graphics.draw(@gridCellGraphic, @gridCellQuad, pos.x, pos.y)

        @gridCellQuad\setViewport(16, 0, @cell.width, @cell.height)
        for x = 1, @columns - 1
            pos = x: (x - 1) * @cell.width, y: (@rows - 1) * @cell.height
            love.graphics.draw(@gridCellGraphic, @gridCellQuad, pos.x, pos.y)

        @gridCellQuad\setViewport(32, 0, @cell.width, @cell.height)
        for y = 1, @rows - 1
            pos = x: (@columns - 1) * @cell.width, y: (y - 1) * @cell.height
            love.graphics.draw(@gridCellGraphic, @gridCellQuad, pos.x, pos.y)

        @gridCellQuad\setViewport(48, 0, @cell.width, @cell.height)
        pos = x: (@columns - 1) * @cell.width, y: (@rows - 1) * @cell.height
        love.graphics.draw(@gridCellGraphic, @gridCellQuad, pos.x, pos.y)

        love.graphics.setColor(255, 255, 255, 255)

    setup: (columns, rows) =>
        Lume.clear(@cells)
        @columns = columns
        @rows = rows
        for y = 1, @rows
            @cells[y] = {}
            for x = 1, @columns
                @cells[y][x] = GridCell!

    load: (mapFilename) =>
        @clear!

        @_file = require mapFilename
        @cell.width = @_file.tilewidth
        @cell.height = @_file.tilewidth
        @setup(@_file.width, @_file.height)

        -- tilesets
        @tilesets = {}

        for i, t in pairs(@_file.tilesets)
            t.tilecount = columns: math.floor(t.imagewidth / t.tilewidth), height: math.floor(t.imageheight / t.tileheight)
            t.texture = love.graphics.newImage("content/#{string.sub(t.image, 4)}")
            @tilesets[t.firstgid] = t


        -- layers
        tileset = @tilesets[1]
        for i, l in pairs(@_file.layers)
            switch l.type
                when "tilelayer"
                    layer = GridTileLayer(l.width, l.height)
                    layer.name = l.name
                    layer.visible = l.visible
                    layer\load(l.data, tileset)

                    Lume.push(@layers, layer)

                    if (l.properties["collision"])
                        for y = 1, layer.rows
                            for x = 1, layer.columns
                                tile = layer.tiles[y][x]
                                @cells[y][x].walkable = (tile == nil)

                when "objectgroup"
                    for i, object in pairs l.objects
                        entity = nil
                        switch object.type
                            when "Player"
                                entity = Player!
                                @scene.player = entity
                            else
                                print "Unhandled object with type '#{object.type}' (at x: #{object.x}, y: #{object.y})."
                                continue

                        entity.x = object.x
                        entity.y = object.y
                        entity.visile = object.visible
                        Lume.push(@entities, entity)
                        @scene\addEntity(entity)
                else
                    print "Undefined grid layer type '#{l.type}'."
                    continue

    clear: =>
        Lume.clear(@layers)

    cellAt: (gridX, gridY) =>
        if (@cells[gridY] == nil)
            return nil

        @cells[gridY][gridX]

    transformToGridPos: (x, y) =>
        ((x - @x) / @cell.width) + 1, ((y - @y) / @cell.height) + 1

    transformToPos: (gridX, gridY) =>
        @x + gridX * @cell.width, @y + gridY * @cell.height
