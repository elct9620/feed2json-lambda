# frozen_string_literal: true

require 'net/http'
require 'delegate'

# Feed Item
#
# @since 0.1.0
class Item < SimpleDelegator
  # Get OG Image
  #
  # @return [String] OG Image URL
  #
  # @since 0.1.0
  def og_image
    @og_image ||= doc.at('//meta[@property="og:image"]/@content').text
  end

  # Feed Item Document
  #
  # @return [Nokogiri::Document]
  #
  # @since 0.1.0
  def doc
    @doc ||= Nokogiri::HTML(Net::HTTP.get(URI(link)))
  end

  # Convert to Hash
  #
  # @return [Hash] Converted HASH
  # @since 0.1.0
  def to_h
    {
      guid: guid.content,
      title: title,
      link: link,
      description: description,
      pubDate: pubDate,
      thumbnail: og_image
    }
  end
end
