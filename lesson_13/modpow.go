package main

import "C"

//export ModPow
func ModPow(base, exp, mod uint64) uint64 {
    result := uint64(1 % mod)
    b := base % mod
    e := exp
    for e > 0 {
        if e&1 == 1 {
            result = (result * b) % mod
        }
        b = (b * b) % mod
        e >>= 1
    }
    return result
}

func main() {}
