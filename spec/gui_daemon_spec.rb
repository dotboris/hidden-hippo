require 'support/cli_controller_examples'

describe 'hh gui', :noisy do
  let(:name) {'gui'}

  it_behaves_like 'cli daemon controller'
end