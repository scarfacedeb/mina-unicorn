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

Make sure the following settings are set in your `config/deploy.rb`:

* `deploy_to`   - deployment path

Make sure the following directories exists on your server:

* `shared/tmp/sockets` - directory for socket files.
* `shared/tmp/pids` - direcotry for pid files.

OR you can set other directories by setting follow variables:

* `unicorn_role`   - unicorn user
* `unicorn_env`    - set environment
* `unicorn_config` - unicorn config file
* `unicorn_cmd`    - bundle exec unicorn
* `unicorn_pid`    - unicorn pid file, default `shared/tmp/pids/unicorn.pid`

Then:

```
$ mina unicorn:start
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/mina-unicorn/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
