RSpec.describe Octofart do
  after(:each) do
    Octofart.instance_variable_set("@config", nil)
  end

  describe "#configure" do
    let!(:token) { "f00bar" }

    it "enables base branch and github token configurable" do
      Octofart.configure do |config|
        config.base_branch  = "develop"
        config.github_token = token
        config.max_retries  = 3
      end

      expect(Octofart.base_branch).to eq("develop")
      expect(Octofart.github_token).to eq(token)
      expect(Octofart.max_retries).to eq(3)
    end
  end
end
