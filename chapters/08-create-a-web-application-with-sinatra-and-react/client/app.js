const main = async () => {
  const pokemons = await fetch('/api/pokemons').then((response) => response.json())

  const component = (
    <table>
      <thead>
        <tr>
          <th title="National Pokédex number">N°</th>
          <th>Sprite</th>
          <th>Name</th>
          <th>Type</th>
        </tr>
      </thead>
      <tbody>
        {
          pokemons.map((pokemon) => {
            const pokemonNumberDisplay = '#' + pokemon.pokemon_number.toString().padStart(3, '0')
            const pokemonNameLowerCase = pokemon.name.toLowerCase()

            return (
              <tr>
                <td>{ pokemonNumberDisplay }</td>
                <td><a href={ `https://www.pokemon.com/us/pokedex/${pokemon.pokemon_number}` }><img src={ `https://img.pokemondb.net/sprites/sun-moon/icon/${pokemonNameLowerCase}.png` }></img></a></td>
                <td><a href={ `https://www.pokemon.com/us/pokedex/${pokemon.pokemon_number}` }>{ pokemon.name }</a></td>
                <td>
                  <ul>
                    {
                      pokemon.types.map((typeName) => {
                        const typeNameLowerCase = typeName.toLowerCase()

                        return (
                          <li class={ `pokemon type ${typeNameLowerCase}` }><a href={ `https://www.pokemon.com/us/pokedex?type=${typeNameLowerCase}` }>{ typeName }</a></li>
                        )
                      })
                    }
                  </ul>
                </td>
              </tr>
            )
          })
        }
      </tbody>
    </table>
  )

  // Render component
  ReactDOM.render(component, document.querySelector('main'))
}

main()
