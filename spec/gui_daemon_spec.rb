require 'support/cli_controller_examples'

describe 'hh gui' do
  let(:name) {'gui'}

  it_behaves_like 'cli daemon controller'
end