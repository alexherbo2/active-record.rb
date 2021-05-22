# Web scraping with Puppeteer

Web scraping of [Pokémon] with [Puppeteer].

[Puppeteer]: https://pptr.dev
[Pokémon]: https://www.pokemon.com

See the [source] for details.

[Source]: src/main.js

## Dependencies

- [Puppeteer]

## Installation

Run the following in your terminal, then open [`pokemon.json`]:

``` sh
make install
make scrape
```

[`pokemon.json`]: data/pokemon.json

You might want to skip [Chromium] download and use your own version:

``` sh
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
export PUPPETEER_EXECUTABLE_PATH=$(which chromium)
```

[Chromium]: https://chromium.org
