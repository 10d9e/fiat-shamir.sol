pragma solidity >=0.4.21 <0.7.0;

// Fiat-Shamir Zero Knowledge proof 
// (non-interactive random oracle access)
contract FiatShamirZKP {
    
    // prime
    uint n;
    // generator
    uint g;
    // g^x mod n
    uint y;
    // TODO Random Challenge Nonce
    uint public c;
    
    // used for pr
    uint nonce;

    // User register's a seed with prime number n, generator g, and y = g^x mod n
    function registerSeed(uint _n, uint _g, uint _y) public {
        // require(probablyPrime(_n), 'n is probably not a prime number');
        n = _n;
        g = _g;
        y = _y;
        // pseudorandom kick
        nonce += uint(keccak256(abi.encodePacked(now, msg.sender, block.coinbase, block.difficulty, nonce, _n, _g, _y))) % n;
    }

    function pseudoRandom() internal returns (uint) {
        uint random = uint(keccak256(abi.encodePacked(now, msg.sender, block.coinbase, block.difficulty, nonce, n, g, y))) % n;
        nonce++;
        return random;
    }

    // TODO generate random challenge number
    function getChallenge() external returns (uint) {
        c = pseudoRandom();
        return c;
    }
    
    /* 
      User wishes to verify, so she generates a new random number and sends product of t:
       t = g^v mod n

      User uses random value (v), and using the challenge in the previous txn, computes for r:
       r = v − c * t
       Contract computes:
       result = g^c * y^c
       and checks if the result equals t equals val
    */
    function verify(uint t, uint256 r) public view returns (bool) {
        uint256 result = 0;
        if (lessThanZero(r)){
            result = (invmod(modexp(g, -r, n), n) * modexp(y, c, n)) % n;
        }else{
            result = (modexp(g, r, n) * modexp(y, c, n)) % n;
        }
        return (t == result);
    }
    
    function lessThanZero(uint256 x) internal pure returns (bool) {
        return (x > 21888242871839275222246405745257275088548364400416034343698204186575808495617);
    }
    
    function modexp(uint256 base, uint256 exponent, uint256 modulus) internal view returns (uint256) {
        uint256[6] memory input;
        uint256[1] memory output;
        input[0] = 0x20;  // length_of_BASE
        input[1] = 0x20;  // length_of_EXPONENT
        input[2] = 0x20;  // length_of_MODULUS
        input[3] = base;
        input[4] = exponent;
        input[5] = modulus;
        assembly {
            if iszero(staticcall(not(0), 5, input, 0xc0, output, 0x20)) {
                revert(0, 0)
            }
        }
        return output[0];
    }

    function modexp(uint256 base, uint256 exponent) internal view returns (uint256) {
        uint256 q = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        return modexp(base, exponent, q);
    }
    
    /// @dev Modular inverse of a (mod p) using euclid.
    /// "a" and "p" must be co-prime.
    /// @param a The number.
    /// @param p The modulus.
    /// @return x such that ax = 1 (mod p)
    function invmod(uint a, uint p) internal pure returns (uint) {
        if (a == 0 || a == p || p == 0)
            revert();
        if (a > p)
            a = a % p;
        int t1;
        int t2 = 1;
        uint r1 = p;
        uint r2 = a;
        uint q;
        while (r2 != 0) {
            q = r1 / r2;
            (t1, t2, r1, r2) = (t2, t1 - int(q) * t2, r2, r1 - q * r2);
        }
        if (t1 < 0)
            return (p - uint(-t1));
        return uint(t1);
    }
    
}