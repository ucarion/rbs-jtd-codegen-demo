# rbs-jtd-codegen-demo

To run this app, you'll need Ruby 3+, and then you can invoke the script as:

```bash
bundle exec ruby lib/ghsearch.rb -- "rails"
```

To perform static type checking, run:

```bash
bundle exec steep check
```

Try messing around with `lib/github.rb`'s `Searcher::search` method to see what
`steep` can catch for you, once you've generated `rb` and `rbs` files using
`jtd-codegen`!

Relevant links:

https://ucarion.com/ruby-rbs-codegen.html

https://jsontypedef.com

https://jsontypedef.com/docs/ruby-codegen/
