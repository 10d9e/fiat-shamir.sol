  
var FiatShamirZKP = artifacts.require("./FiatShamirZKP.sol")

module.exports = function(deployer, network, accounts) {

    deployer.then(async () => {

        console.log('network: ' + network)

        await deployer.deploy(FiatShamirZKP)

        console.log('completed deployment')

    })

};