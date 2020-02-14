# Zero Knowledge Proofs with Fiat-Shamir Heuristic 
### ( aka. Non-Interactive Random Oracle Access for Zero-Knowledge Proofs )

*WIP*

Fiat-Shamir dark alchemy implemented in Solidity as a way for users to provide proofs of secret offchain knowledge without sending hashes vulnerable to dictionary attacks.

gr <sup>yc</sup> = g <sup>v-cx</sup> (g<sup>x</sup>)<sup>c</sup>

= g<sup>v-cx</sup> g<sup>xc</sup>

= g<sup>v-cx+cx</sup>

= g<sup>v</sup>

### Applications
* Offchain password verification. Users can manage their own password data locally and verify it against the smart contract.

### How to use
See [test](https://github.com/jlogelin/crypto/blob/master/test/testFiatShamir.js)

### To Do

Currently the library works well within the confines of solidity's 256 word sizes. This is ok for the purposes of research and experimentation, however it is more desirable to have a smart contract system that plays well with very large primes. Fortunately, new iterations of the EVM have included opcodes that map to bignumber precompile operations (mod, expmod, etc.).

[Zcoin BigNumber Library](https://github.com/zcoinofficial/solidity-BigNumber)

### References
[How To Prove Yourself: Practical Solutions to Identification and Signature Problems ](https://link.springer.com/content/pdf/10.1007/3-540-47721-7_12.pdf)
