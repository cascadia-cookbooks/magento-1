require 'spec_helper'

describe 'magento::default' do
end

describe 'magento::users' do
    users = %w(
        mage-cli
    )

    users.each do |user|
        describe user(user) do
            it { should exist }
            it { should belong_to_group 'www-data' }
            it { should have_home_directory "/home/#{user}" }
        end
    end
end

describe 'magento::robots' do
    describe file('/var/www/example.com/shared/pub/robots.txt') do
        it { should exist }
        it { should be_owned_by 'mage-cli' }
        it { should be_grouped_into 'www-data' }
        it { should be_mode 644 }
    end

    describe file('/var/www/example.com/current/magento/pub/robots.txt') do
        it { should exist }
        it { should be_symlink }
        it { should be_owned_by 'mage-cli' }
        it { should be_grouped_into 'www-data' }
    end
end

describe 'magento::composer-prep' do
    describe file('/home/mage-cli/.composer/auth.json') do
        it { should exist }
        it { should be_owned_by 'mage-cli' }
        it { should be_grouped_into 'cli' }
        it { should be_mode 644 }
    end

    describe file('/var/www/example.com/shared/composer/auth.json') do
        it { should exist }
        it { should be_owned_by 'www-data' }
        it { should be_grouped_into 'www-data' }
        it { should be_mode 644 }
    end

    describe file('/var/www/example.com/shared/composer/composer.json') do
        it { should exist }
        it { should be_owned_by 'www-data' }
        it { should be_grouped_into 'www-data' }
        it { should be_mode 644 }
    end
end

describe 'magento::n98' do
    describe file('/usr/local/bin/n98-magerun2') do
        it { should exist }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode 755 }
    end
end
