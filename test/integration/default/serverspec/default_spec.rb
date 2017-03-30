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
            it { should be_mode 755 }
        end
    end
end

describe 'magento::permissions' do
    describe file('/var/test') do
        it { should be_directory }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode 755 }
    end 

    describe file('/var/test.file') do
        it { should exist }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode 755 }
    end 
end

describe 'magento::robots' do
    describe file('/var/www/shared/pub/robots.txt') do
        it { should exist }
        it { should be_owned_by 'mage-cli' }
        it { should be_grouped_into 'www-data' }
        it { should be_mode 644 }
    end
end
