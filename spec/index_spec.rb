require_relative "../index"

describe LinguistHandler, "Handler" do
  context = {}
  image = {
    "name" => "image.jpg",
    "data" => Base64.encode64(File.read("fixtures/image.jpg", :encoding => "ASCII-8BIT")),
  }
  sql = {
      "name" => "db.sql",
      "data" => Base64.encode64(File.read("fixtures/db.sql", :encoding => "ASCII-8BIT")),
  }
  html = {
      "name" => "pages.html",
      "data" => Base64.encode64(File.read("fixtures/pages.html", :encoding => "ASCII-8BIT")),
  }

  describe "#process" do
    it "should detect image" do
      result = LinguistHandler::Handler.process(event: image, context: context)
      expect(result).to eq({
                               :lines => 0,
                               :sloc => 0,
                               :type => "Image",
                               :mime_type => "image/jpeg",
                               :language => nil,
                           })
    end

    it "should detect sql" do
      result = LinguistHandler::Handler.process(event: sql, context: context)
      expect(result).to eq({
                               :lines => 225,
                               :sloc => 191,
                               :type => "Text",
                               :mime_type => "application/x-sql",
                               :language => "SQL",
                           })
    end

    it "should detect html" do
      result = LinguistHandler::Handler.process(event: html, context: context)
      expect(result).to eq({
                               :lines => 31,
                               :sloc => 31,
                               :type => "Text",
                               :mime_type => "text/html",
                               :language => "HTML",
                           })
    end

    it "should handle malformed payload" do
      result = LinguistHandler::Handler.process(event: {}, context: context)
      expect(result).to eq({
                               :lines => 0,
                               :sloc => 0,
                               :type => "Text",
                               :mime_type => "text/plain",
                               :language => nil,
                           })
    end
  end

  describe "#process_apigw" do
    it "should detect image" do
      event = {
          "body" => JSON.generate(image),
          "isBase64Encoded" => false,
      }

      response = LinguistHandler::Handler.process_apigw(event: event, context: context)
      expect(response).to eq({
                                 statusCode: 200,
                                 headers: { "Content-Type": "application/json" },
                                 body: JSON.generate({ data: {
                                     :lines => 0,
                                     :sloc => 0,
                                     :type => "Image",
                                     :mime_type => "image/jpeg",
                                     :language => nil,
                                 } }),
                             })
    end

    it "should detect sql" do
      event = {
          "body" => JSON.generate(sql),
          "isBase64Encoded" => false,
      }

      response = LinguistHandler::Handler.process_apigw(event: event, context: context)
      expect(response).to eq({
                                 statusCode: 200,
                                 headers: { "Content-Type": "application/json" },
                                 body: JSON.generate({ data: {
                                     :lines => 225,
                                     :sloc => 191,
                                     :type => "Text",
                                     :mime_type => "application/x-sql",
                                     :language => "SQL",
                                 } }),
                             })
    end

    it "should detect html" do
      event = {
          "body" => JSON.generate(html),
          "isBase64Encoded" => false,
      }

      response = LinguistHandler::Handler.process_apigw(event: event, context: context)
      expect(response).to eq({
                                 statusCode: 200,
                                 headers: { "Content-Type": "application/json" },
                                 body: JSON.generate({ data: {
                                     :lines => 31,
                                     :sloc => 31,
                                     :type => "Text",
                                     :mime_type => "text/html",
                                     :language => "HTML",
                                 } }),
                             })
    end

    it "should handle malformed payload" do
      response = LinguistHandler::Handler.process_apigw(event: {}, context: context)
      expect(response).to eq({
                                 statusCode: 200,
                                 headers: { "Content-Type": "application/json" },
                                 body: JSON.generate({ data: {
                                     :lines => 0,
                                     :sloc => 0,
                                     :type => "Text",
                                     :mime_type => "text/plain",
                                     :language => nil,
                                 } }),
                             })
    end
  end
end