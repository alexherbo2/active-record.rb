const puppeteer = require('puppeteer')
const fs = require('fs')

const main = async () => {
  const browser = await puppeteer.launch()
  const page = await browser.newPage()

  // Start page
  await page.goto('https://www.pokemon.com/us/pokedex/bulbasaur')

  // Pokémon
  const pokemons = []

  for (let index = 1; index <= 151; index++) {
    const { pokemon, nextPageURL } = await page.evaluate(() => {
      // Pokémon
      const pokemon = {}

      // Gets attributes by name:
      const getAttributesByName = (name) => {
        return Array.from(Array.from(document.querySelectorAll('.pokemon-ability-info .attribute-title')).find((element) => element.textContent === name).parentElement.querySelectorAll('.attribute-value'), (element) => element.textContent.trim())
      }

      // Gets a specific stat by name:
      const getStatByName = (name) => {
        return Number(Array.from(document.querySelectorAll('.pokemon-stats-info > ul > li')).find((element) => element.querySelector('span').textContent === name).querySelector('.meter').dataset.value)
      }

      // Gets evolutions:
      const getEvolutions = () => {
        const evolutions = []

        const evolutionElement = Array.from(document.querySelectorAll('.evolution-profile a')).find((link) => link.href === location.href).parentElement.nextElementSibling

        if (evolutionElement) {
          const pokemonNames = Array.from(evolutionElement.querySelectorAll('a h3'), (element) => element.firstChild.textContent.trim())

          evolutions.push(...pokemonNames)
        }

        return evolutions
      }

      // Collect data
      pokemon.index = Number(document.querySelector('.pokedex-pokemon-pagination-title .pokemon-number').textContent.match(/#([0-9]+)/)[1])
      pokemon.name = document.querySelector('.pokedex-pokemon-pagination-title div').firstChild.textContent.trim()
      pokemon.category = getAttributesByName('Category')[0]
      pokemon.abilities = getAttributesByName('Abilities')
      pokemon.type = Array.from(document.querySelectorAll('.dtm-type li a'), (link) => link.textContent.trim())
      pokemon.weaknesses = Array.from(document.querySelectorAll('.dtm-weaknesses li a'), (link) => link.textContent.trim())
      pokemon.stats = {}
      pokemon.stats.hp = getStatByName('HP')
      pokemon.stats.attack = getStatByName('Attack')
      pokemon.stats.defense = getStatByName('Defense')
      pokemon.stats.special_attack = getStatByName('Special Attack')
      pokemon.stats.special_defense = getStatByName('Special Defense')
      pokemon.stats.speed = getStatByName('Speed')
      pokemon.evolutions = getEvolutions()

      // Get the next page to navigate
      const nextPageURL = document.querySelector('.pokedex-pokemon-pagination a.next').href

      return { pokemon, nextPageURL }
    })

    // Log message
    console.log(pokemon)

    // Push data and navigate to the next page
    pokemons.push(pokemon)
    await page.goto(nextPageURL)
  }

  // Write data
  await fs.writeFile('data/pokemon.json', JSON.stringify(pokemons, undefined, 2), (error) => {})

  // Close browser
  await browser.close()
}

main()
