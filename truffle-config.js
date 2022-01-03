require('babel-register');
require('babel-polyfill');

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 7545,
            network_id: "*" // Match any network id
        },
    },  // Use this to deploy to a public network.
    contracts_directory: './src/contracts/',
    contracts_build_directory: './src/abis/',
    compilers: {
        solc: {
            version: "0.8.11",
            optimizer: {
                enabled: true,
                runs: 200
            }  // Default: 200
        }   // Default: version: "0.8.11",
    } 
};