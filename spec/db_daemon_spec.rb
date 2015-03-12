require 'support/cli_controller_examples'

describe 'hh db' do
  let(:name) {'db'}

  it_behaves_like 'cli daemon controller'
end