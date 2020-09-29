# Solidity Zero Knowledge Proofs with Fiat-Shamir Heuristic 
### ( aka. Interactive Random Oracle Access for Zero-Knowledge Proofs )

*WIP*

Fiat-Shamir dark alchemy implemented in Solidity as a way for users to provide proofs of secret offchain knowledge without sending hashes vulnerable to dictionary attacks. Instead of a trusted setup ceremony as with a zk-snark, the "zk-niro" users derive proofs with a secret random nonce and and public random challenge from the contract during each proof verification.

### Applications
* Offchain password/data verification. Users can manage their own data locally and offchain and verify it's existance against a smart contract.

### How to use
For concrete example see [test](https://github.com/jlogelin/crypto/blob/master/test/testFiatShamir.js)

1. Generate a random prime number (n) and generator value(g).
2. Hash secret data offchain (x) Calculate (y) value as: y = g<sup>x</sup> <sub>(mod n)</sub>
3. Send (n, g, y) as seed values to the `FiatShamirZKP.registerSeed()` function.
4. Later, when the user wishes to verify offchain data, retrieve random challenge (c) from contract with `FiatShamirZKP.getChallenge()`
5. User generates a random number (v) between 0 and n and calculates (t) as: t = g<sup>v</sup> <sub>(mod n)</sub>
6. User calculates (r) as: r = v - c * x
7. User sends t and r as the zkproof to `FiatShamirZKP.verify()`. (At no point is x or v sent to the contract)
8. The contract calculates ( g<sup>r</sup> <sub>(mod n)</sub> * y<sup>c</sup> <sub>(mod n)</sub> ) verifying the resulting value with t.

The proof works because:

gr <sup>yc</sup> = g <sup>v-cx</sup> (g<sup>x</sup>)<sup>c</sup>

= g<sup>v-cx</sup> g<sup>xc</sup>

= g<sup>v-cx+cx</sup>

= g<sup>v</sup>

### To Do

Currently the library works well within the confines of solidity's 256 bit word sizes. This is ok for the purposes of research and experimentation, however it is more desirable to have a smart contract system that plays well with very large primes. Fortunately, new iterations of the EVM have included opcodes that map to bignumber precompile operations (mod, expmod, etc.) and there has been some research and development integrating these functions into solidity.

[Zcoin BigNumber Library](https://github.com/zcoinofficial/solidity-BigNumber)

### References
[How To Prove Yourself: Practical Solutions to Identification and Signature Problems ](https://link.springer.com/content/pdf/10.1007/3-540-47721-7_12.pdf)

Special thanks to [Professor Bill Buchanan, OBE](https://www.youtube.com/watch?v=n2WUJyk9cHA)
