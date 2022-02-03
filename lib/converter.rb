# frozen_string_literal: true

require 'net/http'
require 'delegate'

require_relative './item'

# The RSS Feed Converter
#
# @since 0.1.0
class Converter < SimpleDelegator
  class << self
    # Create Feed Delegator
    #
    # @since 0.1.0
    def load(url)
      new(RSS::Parser.parse(Net::HTTP.get(URI(url))))
    end
  end

  include Enumerable

  # @since 0.1.0
  def each
    return enum_for(:each) unless block_given?

    items.each do |item|
      yield Item.new(item)
    end
  end

  # Convert To Hash
  #
  # @return [Hash]
  #
  # @since 0.1.0
  def to_h
    {
      title: channel.title,
      lastBuildDate: channel.lastBuildDate,
      items: Parallel.map(self, &:to_h)
    }
  end

  # Convert to JSON
  #
  # @return [String]
  #
  # @since 0.1.0
  def to_json(**options)
    to_h.to_json(**options)
  end
end
