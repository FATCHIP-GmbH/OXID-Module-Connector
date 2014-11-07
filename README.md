# ioly

> "Everybody loves ioly!"

ioly helps you easily integrate modules into your PHP application. You can use it with any system that supports modules/extensions/packages etc..

## Getting started

1. download ioly
2. configure the ioly settings for your environment
3. search for a recipe
4. install recipe
4. done


## Installation

Download `ioly` core via console or via HTTP or:

`curl -O https://raw.githubusercontent.com/ioly/ioly/core/ioly.php`

Using `ioly` module manager via console. In this example, we'll add a module to an installation of OXID eSales:

``` sh
$ export IOLY_SYSTEM_BASE=/var/www/myshop.de/;
$ export IOLY_SYSTEM_VERSION=4.8;
$ php ioly.php update;
$ php ioly.php list;
$ php ioly.php search paypal;
$ php ioly.php install paypal;
$ php ioly.php show oxid/paypal;
$ php ioly.php install oxid/paypal 3.2.1;
```

### Contributing

1. write a recipe
2. commit your recipe
3. send a merge request
4. done, everybody can use it!

[Read more here!](https://github.com/ioly/ioly/wiki/Contributing-to-the-ioly-cookbook)

##### Example
``` json
  {
      "name": "PayPal",
      "vendor": "oxid",
      "type": "oxid",
      "license": "GNU",
      "desc": "PayPal payment method for checkout.",
      "tags": [
          "frontend",
          "paypal",
          "payment",
          "checkout"
      ],
      "versions": {
          "3.2.1": {
              "project": "https://github.com/OXID-eSales/paypal/tree/v3.2.1",
              "url": "https://github.com/OXID-eSales/paypal/archive/v3.2.1.zip",
              "supported": [
                  	"4.9",
                  	"4.8",
                  	"4.7"
              ],
              "mapping": [
              	{
                  	"src": "source/modules/oe/",
                  	"dest": "modules/oe/"
              	}
              ]
          }
      }
  }
```

[Read more about writing a recipe.](https://github.com/ioly/ioly/wiki/Writing-a-recipe)


### Requirements

- PHP 5.3.0 or above (at least 5.3.4 recommended to avoid potential bugs)
- PHP extensions:
  * cUrl
  * JSON
  * Phar
  * ZIP


### Authors
---
Dave Holloway - <http://www.gn2-netwerk.de> - <http://twitter.com/dajoho><br />
Tobias Merkl - <http://www.proudsourcing.de> - <http://twitter.com/tabsl><br />
Stefan Moises - <http://www.rent-a-hero.de> - <http://twitter.com/smxsm><br />

You can also view the list of [contributors](https://github.com/ioly/ioly/contributors) who participated in this project.


License
---
ioly is licensed under the MIT License - see the LICENSE file for details.
