RSpec.describe Octofart::Parser do
  let(:file) { File.join(File.dirname(__FILE__), "..", "fixtures", "filename.json") }
  let(:parser) { Octofart::Parser.new(file) }

  describe "#parse" do
    context "with valid file" do
      it "returns a json" do
        expect(parser.parse).not_to be_nil
      end
    end

    context "with invalid file" do
      before { parser.file = "'foo' => 'bar'" }

      it { expect { parser.parse }.to raise_error(ArgumentError) }
    end

    context "with unsupplied file" do
      before { parser.file = nil }

      it { expect { parser.parse }.to raise_error(ArgumentError) }
    end
  end
end
