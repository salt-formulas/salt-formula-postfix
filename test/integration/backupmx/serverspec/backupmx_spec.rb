
require_relative './spec_helper'

describe 'server.sls' do

  describe package('postfix') do
    it { should be_installed }
  end

  #describe service('postfix') do
    #it { should be_enabled }
    #it { should be_running }
  #end

end
