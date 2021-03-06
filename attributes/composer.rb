normal['composer'] = {
    binary: {
        path: '/usr/local/bin/composer'
    }
}

default['magento']['composer'] = {
    description: 'eCommerce Platform for Growth (Enterprise Edition)',
    merge: {
        version: 'v1.3.1',
        recurse: false,
        replace: true,
        merge_dev: true,
        merge_extra: true
    },
    name: 'magento/copious-dev-box',
    repositories: {
        'repo.magento.com' => {
            username: '',
            password: ''
        },
        copious_repos: {
            token: ''
        }
    }
}
