var bigInt = require("big-integer");
const Web3 = require('web3')
const web3 = new Web3()
//var BN = web3.utils.BN;

var FiatShamirZKP = artifacts.require("./FiatShamirZKP.sol")

// Prime Number
let n = 15485867n
//let n = 16238557847571361432079207259416643917456544702863121607771071554190210386009n
// Generator value
let g = 2n

// Prover's Secret variables
let secret = 'hello world'
// Prover's hash mod n secret
let x = BigInt(web3.utils.keccak256(secret)) % n
// Prover's random nonce - generated in phase 2
var v

// Verifier's challenge
var c

contract('Test Fiat-Shamir Zero Knowledge Proof contract', async (accounts) => {

    it("Preflight checks", async () => {
        // (2^256)-1
        assert(n < (2**256)-1)
        console.log(x.toString())
    })

    it("Phase 1: Register seed", async () => {        
        console.log('Calculate seed')
        let zkp = await FiatShamirZKP.deployed()
        let y = bigInt(g).modPow(x, n)
        console.log('Registering seed:', n.toString(), g.toString(), y.toString())
        await zkp.registerSeed(n.toString(), g.toString(), y.toString())
        console.log('Seed successfully registered')
    })

    it("Phase 2: Random Nonces", async () => {
        let zkp = await FiatShamirZKP.deployed()

        // prover generates random nonce
        v = BigInt(bigInt.randBetween(0, n))

        // prover gets random challenge
        await zkp.getChallenge()

        // get the challenge
        c = BigInt( await zkp.c.call() )
        console.log('challenge:', c)
    })

    it("Phase 3: Verify Proof", async () => {
        let zkp = await FiatShamirZKP.deployed()

        let t = bigInt(g).modPow(v, n)
        console.log('t=', t)

        // prover creates verification proof r
        // and passes to verify function, only the prover
        // knows the values of x and v
        let r = (v - c * x);
        console.log('r: ', r.toString())

        // let valid = await zkp.verify.call(r.toString())
        let valid = await zkp.verify(t.toString(), r.toString())
        console.log('valid', valid)
        assert( valid == true )
    })

    const pickGenerator = function(p) {
        for(var x = 0n; x < p; x++) {
            let rand = x
            let exp = 1
            next = rand % p

            while(next != 1) {
                next = (next*rand) % p
                exp = exp + 1
            }

            if(exp == p-1) {
                return rand
            }
        }
    }

})
