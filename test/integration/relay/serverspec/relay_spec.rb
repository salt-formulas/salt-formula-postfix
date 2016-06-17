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

describe 'relay.sls' do

  describe package('postfix') do
    it { should be_installed }
  end

  describe service('postfix') do
    it { should be_enabled }
    it { should be_running }
  end

  context 'configures' do
    describe file("#{postfix_conf_path}/main.cf") do
      its(:content) { should match(/^relayhost = cloudlab.cz/) }
      its(:content) { should match(/^smtp_tls_.*protocols = !SSLv2,!SSLv3/) }
    end
  end

end

describe 'relay.sls, sasl_passwd' do

  let(:sasl_passwd_file) { '/etc/postfix/sasl_passwd' }

  it 'manages postfix sasl_passwd' do
    expect(file(sasl_passwd_file).content).to match(/relay@cloudlab.cz:aes9aemiexohm7oohin4Amab9thahgha/)
  end

  it 'configures postfix to use the sasl_passwd file' do
    expect(file('/etc/postfix/main.cf').content).to match(/^\s*smtp_sasl_password_maps\s*=.*#{sasl_passwd_file}\s*$/)
  end
end

