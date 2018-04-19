# Octofart :dash:

As we continuously create new repositories in our organization, there can be
a time when you need to update a single line of code across multiple
repositories, hence, this gem aims to solve that problem.

Octofart (Octokit - Find And Replace Text) provides a nice looking DSL that automates bulk update of code from all repositories within your organization.

## Sample use cases

- Updating hard-coded ruby versions from multiple repositories (i.e `s/2.4.2/2.5.0`)
- Updating typo errors
- Renaming class names (i.e `s/FactoryGirl/FactoryBot`)

## DSL

```ruby
Octofart.workflow {
  organization "quipper"

  task find: "FactoryGirl",
       replace: "FactoryBot",
       message: "Updates FactoryGirl class names to FactoryBot"

  # You can add as many commits as you want
  task find: "git ocmmit",
       replace: "git commit",
       message: "Fixes typo errors of `git commit` from bash scripts"

  pull_request title: "Bulk update ",
               body: "Please Review, Onii-chan!",
               branch_name: "rbmrclo-#{Time.now.to_i}"
}

```

## Workflow

- Octofart takes advantage of Github API to perform full text search of the code.
- Response will be parsed and files that matches the mapping will be updated.
- Octofart will commit the changes, push it on a new branch, and create a pull request.
- The merging of PR can be done by a developer to ensure that the changes are correct.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'octofart'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install octofart

## Configuration

```ruby
Octofart.configure do |config|
  config.github_token = ENV['GITHUB_USER_TOKEN']
  config.max_retries  = 3
end
```

## Tests

```
$ bundle exec rspec spec
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rbmrclo/octofart.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
