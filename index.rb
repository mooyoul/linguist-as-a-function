require 'rubygems'
require 'bundler/setup'
require "base64"
require "json"
require "linguist"

module LinguistHandler
  class Handler
    def self.process(event:, context:)
      name = event["name"] || ""
      data = Base64.decode64(event["data"] || "")

      detect(path: name, data: data)
    end

    def self.process_apigw(event:, context:)
      is_base64_encoded = event["isBase64Encoded"] || false
      raw_body = event["body"] || ""

      body =
        begin
          if is_base64_encoded
            JSON.parse(Base64.decode64(raw_body))
          else
            JSON.parse(raw_body)
          end
        rescue
          nil
        end

      result =
        if body
          name = body["name"]
          data = Base64.decode64(body["data"] || "")

          detect(path: name, data: data)
        else
          nil
        end

      {
          statusCode: 200,
          headers: {
              "Content-Type": "application/json",
          },
          body: JSON.generate({ data: result }),
      }
    end

    private

    def self.detect(path:, data:)
      blob = Linguist::Blob.new(path, data)
      language = Linguist.detect(blob)

      if language
        { name: language.to_s }
      else
        nil
      end
    end
  end
end