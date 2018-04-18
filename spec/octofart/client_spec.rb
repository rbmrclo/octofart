RSpec.describe Octofart::Client do
  let(:access_token) { "t0k3n" }
  let(:client) { Octofart::Client.new(access_token: access_token) }

  describe "retrying a method that mutates args" do
    subject { client.contents("some/repo", path: "important_path.json") }

    context "when the request has to be retried" do
      before do
        repo_url = "https://api.github.com/repos/some/repo"
        stub_request(:get, "#{repo_url}/contents/important_path.json").
          with(headers: {
            'Accept'=>'application/vnd.github.v3+json',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'token t0k3n',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Octokit Ruby Gem 4.8.0'
          }).to_return(
            { status: 502, headers: { "content-type" => "application/json" } },
            {
              status: 200,
              body: fixture("filename.json"),
              headers: { "content-type" => "application/json" }
            }
          )
      end

      it { expect(subject.name).to eq("Gemfile") }
    end
  end

end
