# Mina::Unicorn

[Mina](https://github.com/nadarei/mina) tasks for handle with
[Unicorn](http://unicorn.bogomips.org/)

This gem provides several mina tasks:

    mina unicorn:start           # Start unicorn
    mina unicorn:stop            # Stop unicorn
    mina unicorn:restart         # Restart unicorn (with zero-downtime)

## Installation

Add this line to your application's Gemfile:

    gem 'mina-unicorn', :require => false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mina-unicorn

## Usage

Add this to your `config/deploy.rb` file:

    require 'mina/unicorn'

Make sure to add the following directories to `:shared_paths` in `config/deploy.rb`:

```ruby
set :shared_paths, ['tmp/sockets', 'tmp/pids']
```

You can also set individual config variables to override default values for
unicorn:

* `unicorn_env`    - set unicorn environment, default: depending on `rails_env`: `development` or `deployment` (see: [Rack environment](http://unicorn.bogomips.org/unicorn_1.html#rack-environment))
* `rails_env`      - set rails environment, default: `production`
* `unicorn_config` - unicorn config file, default: `config/unicorn.rb`
* `unicorn_cmd`    - bundle exec unicorn, default: `RAILS_ENV=production bundle exec unicorn` (see: [mina/rails](https://github.com/mina-deploy/mina/blob/master/lib%2Fmina%2Frails.rb#L25))
* `unicorn_pid`    - unicorn pid file, default: `tmp/pids/unicorn.pid`

Then:

```
$ mina unicorn:start
```

## Contributing

1. Fork it ( http://github.com/scarfacedeb/mina-unicorn/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
