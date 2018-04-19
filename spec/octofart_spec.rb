RSpec.describe Octofart do
  describe "#configure" do
    after(:each) do
      Octofart.instance_variable_set("@config", nil)
    end

    let!(:token) { "f00bar" }

    it "enables base branch and github token configurable" do
      Octofart.configure do |config|
        config.github_token = token
        config.max_retries  = 3
      end

      expect(Octofart.github_token).to eq(token)
      expect(Octofart.max_retries).to eq(3)
    end
  end

  describe "#workflow" do
    context "when no supplied block" do
      it "raises an error" do
        expect { Octofart.workflow }.to raise_error(ArgumentError)
      end
    end

    context "when a block is supplied" do
      subject do
        Octofart.workflow {
          organization "foo"
          task find: "this", replace: "that", message: "test"
          pull_request body: "test body", title: "test title"
        }
      end

      let!(:request_headers) do
        {
          'Accept'=>'application/vnd.github.v3+json',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Octokit Ruby Gem 4.8.0'
        }
      end

      let!(:response_headers) do
        { "content-type" => "application/json" }
      end

      before do
        @search_stub = stub_request(:get, "https://api.github.com/search/code?q=this%20in:file%20org:foo")
          .with(headers: request_headers)
          .to_return(status: 200, body: fixture("search.json"), headers: response_headers)

        @repo_stub = stub_request(:get, "https://api.github.com/repos/jquery/jquery")
          .with(headers: request_headers)
          .to_return(status: 200, body: fixture("repo.json"), headers: response_headers)

        @branch_stub = stub_request(:get, "https://api.github.com/repos/jquery/jquery/branches/master")
          .with(headers: request_headers)
          .to_return(status: 200, body: fixture("branch.json"), headers: response_headers)

        @ref_stub = stub_request(:get, "https://api.github.com/repos/jquery/jquery/git/refs/heads/find-and-replace-text")
          .with(headers: request_headers)
          .to_return(status: 200, body: fixture("ref.json"), headers: response_headers)

        @content_stub = stub_request(:get, "https://api.github.com/repos/jquery/jquery/contents/src/attributes/classes.js?branch=master")
          .with(headers: request_headers)
          .to_return(status: 200, body: fixture("content.json"), headers: response_headers)

        @blob_stub = stub_request(:post, "https://api.github.com/repos/jquery/jquery/git/blobs")
          .with(
            body: "{\"content\":\"Zm9vYmFy\\n\",\"encoding\":\"base64\"}",
            headers: request_headers
          ).to_return(status: 200, body: fixture("blob.json"), headers: response_headers)

        @get_commit_stub = stub_request(:get, "https://api.github.com/repos/jquery/jquery/commits/asd")
          .with(headers: request_headers)
          .to_return(status: 200, body: fixture("commit.json"), headers: response_headers)

        @tree_stub = stub_request(:post, "https://api.github.com/repos/jquery/jquery/git/trees")
          .with(
            body: "{\"base_tree\":\"3rg32342sha1\",\"tree\":[{\"path\":\"src/attributes/classes.js\",\"mode\":\"100644\",\"type\":\"blob\",\"sha\":\"asd1231231312sha1\"}]}",
            headers: request_headers
          ).to_return(status: 200, body: fixture("tree.json"), headers: response_headers)

        @post_commit_stub = stub_request(:post, "https://api.github.com/repos/jquery/jquery/git/commits")
          .with(
            body: "{\"message\":\"test\",\"tree\":\"12321afasha1\",\"parents\":[\"asd\"]}",
            headers: request_headers
          ).to_return(status: 200, body: fixture("commit.json"), headers: response_headers)

        @patch_ref_stub = stub_request(:patch, "https://api.github.com/repos/jquery/jquery/git/refs/heads/find-and-replace-text")
          .with(
            body: "{\"sha\":\"12321jsfsdfssha1\",\"force\":true}",
            headers: request_headers
          ).to_return(status: 200, body: fixture("ref.json"), headers: response_headers)

        @pull_request_stub = stub_request(:post, "https://api.github.com/repos/jquery/jquery/pulls")
          .with(
            body: "{\"base\":\"master\",\"head\":\"123\",\"title\":\"test title\",\"body\":\"test body\"}",
            headers: request_headers
          ).to_return(status: 200, body: fixture("pull_request.json"), headers: response_headers)
      end

      it "works" do
        expect { subject }.not_to raise_error
      end

      it "sends api requests" do
        subject

        expect(@search_stub).to have_been_requested
        expect(@repo_stub).to have_been_requested
        expect(@branch_stub).to have_been_requested
        expect(@ref_stub).to have_been_requested
        expect(@content_stub).to have_been_requested
        expect(@blob_stub).to have_been_requested
        expect(@get_commit_stub).to have_been_requested
        expect(@tree_stub).to have_been_requested
        expect(@post_commit_stub).to have_been_requested
        expect(@patch_ref_stub).to have_been_requested
        expect(@pull_request_stub).to have_been_requested
      end
    end
  end
end
