# CGen

CGen is the next **localized Curriculum Vitae** editor, both for hackers and end-users.

*Please note that this is still in early development stages. If you are an end-user you may want to check this project out in a couple of weeks.*

## Installation

Via homebrew

    $ brew install cgen
    
Via rubygems

    $ gem install curriculum-generator


## Usage

CGen provides two editing modes:
1. **Hacking Mode**
2. **Normal Mode**

### Hacking Mode

This is where CGen shrines, by allowing users to **just provide the data** and let the system do the rest. This system comes with *extensibility* in mind, by providing different levels of customization:
1. **Data-level**: The first level is the most commonly used. The system automatically pulls all of your defined data. This means that there isn't anything wired-in, no names, no values, anything. Data is just data and you can use it as you want !
2. **Templates-level**: For basic customizations you can write your own (LaTeX) **templates**, or modify an existing one.
3. **Generators-level**: For more advanced customizations, you can write your own (Ruby) **generators**.

### Normal Mode

This is primarly for non-hackers. In this mode the curriculum is edited by using a GUI.

*This mode is still in development: not released yet*.

## Contributing

### Project management

#### Scrum & Trello

The project follows the **Scrum Methodology**, using Trello as the main tool.

The board is available under: [CGen Trello Board](https://trello.com/b/8er5R7dK/cgen)

#### Report bugs / Request enhancements

Create a new card in the *Product Backlog* list:

* With the *red* label for bug reporting
* With the *blue* label to request an enhancement

### Fork-Pull pattern

The project contribution is commonly done by using the so-much-famous *fork-pull pattern*:

1. Fork it ( https://github.com/[my-github-username]/cgen/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
