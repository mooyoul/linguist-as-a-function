require_relative "../index"

describe LinguistHandler, "Handler" do
  context = {}

  describe "#process" do
    context "with supported language" do
      it "should return detected language" do
        event = {
            "name" => "test.sql",
            "data" => "SELECT * FROM table WHERE id = 123"
        }

        result = LinguistHandler::Handler.process(event: event, context: context)
        expect(result).to eq({ name: "SQL" })
      end
    end

    context "with malformed payload" do
      it "should return nil" do
        result = LinguistHandler::Handler.process(event: {}, context: context)
        expect(result).to eq(nil)
      end
    end
  end

  describe "#process_apigw" do
    context "with supported language" do
      it "should return detected language" do
        event = {
          "body" => JSON.generate({
            "name" => "test.sql",
            "data" => "SELECT * FROM table WHERE id = 123"
          }),
          "isBase64Encoded" => false,
        }

        response = LinguistHandler::Handler.process_apigw(event: event, context: context)
        expect(response).to eq({
          statusCode: 200,
          headers: { "Content-Type": "application/json" },
          body: JSON.generate({ data: { name: "SQL"} }),
        })
      end
    end

    context "with malformed payload" do
      it "should return nil" do
        result = LinguistHandler::Handler.process_apigw(event: {}, context: context)

        expect(result).to eq({
          statusCode: 200,
          headers: { "Content-Type": "application/json" },
          body: JSON.generate({ data: nil }),
        })
      end
    end
  end
end