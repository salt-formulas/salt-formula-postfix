# encoding: utf-8
# Copyright 2012, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require_relative './spec_helper'

describe 'server.sls' do

  context 'configures' do
    describe file("#{postfix_conf_path}/main.cf") do
      its(:content) { should match(/^smtp_tls_.*protocols = !SSLv2,!SSLv3/) }
      its(:content) { should match(/^message_size_limit = 25000000/) }
      its(:content) { should match(/^content_filter = amavisfeed/) }
    end
  end

end


unless docker_env
# service check are disabled by default CI, see more in .kitchen.docker.yml

  describe 'services' do
    context 'enabled, running' do

      describe service('postfix') do
        it { should be_enabled }
        it { should be_running }
      end

      describe service('mailman') do
        it { should be_enabled }
        it { should be_running }
      end

      # AMAVIS not enabled by default
      #describe service('amavis') do
        #it { should be_enabled }
        #it { should be_running }
      #end

      #describe service('clamav') do
        #it { should be_enabled }
        #it { should be_running }
      #end

      #describe service('freshclam') do
        #it { should be_enabled }
        #it { should be_running }
      #end
    end
  end
end
