require 'spec_helper'

describe 'magento::default' do
end

describe 'magento::cli-tools' do
    tools = %w(
        composer
        n98-magerun2
    )
    
    tools.each do |tool|
        describe file("/usr/local/bin/#{tool}") do
            it { should exist }
            it { should be_owned_by 'mage-cli' }
            it { should be_grouped_into 'cli' }
            it { should be_mode '0755' }
        end
    end
end
