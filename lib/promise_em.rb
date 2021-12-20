# frozen_string_literal: true

require_relative "promise_em/version"
require "bundler/setup"

Bundler.require

# JavaScript like promise for EventMachine library
module PromiseEm
  class Error < StandardError; end

  autoload(:Promise, "promise_em/promise")
end
