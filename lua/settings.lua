local settings = { }
settings.game_name = "LD41"
settings.description = "Game made in 72 hours to Ludum Dare 41."
settings.link = "-"
settings.authors = {
  ["Lucas A. Miranda"] = {
    role = "programmer",
    links = {
      twitter = "@itsmappache",
      github = "github.com/lucas-miranda"
    }
  },
  ["Rey"] = {
    role = "artist",
    links = {
      twitter = "@reylisten",
      itchio = "reylisten.itch.io"
    }
  }
}
settings.title = lume.format("{1}", {
  settings.game_name
})
settings.pixel_scale = 1
settings.screen_size = {
  width = 320,
  height = 180
}
settings.window_size = {
  width = settings.screen_size.width * settings.pixel_scale,
  height = settings.screen_size.height * settings.pixel_scale
}
settings.atlas_name = "main atlas"
return settings
