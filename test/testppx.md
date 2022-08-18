# Integers
```ocaml
# 0z ;;
- : Z.t = 0
# 1z ;;
- : Z.t = 1
# -1z ;;
- : Z.t = -1
# 123z ;;
- : Z.t = 123
# -0b010z ;;
- : Z.t = -2
# 0o147z ;;
- : Z.t = 103
# -0O123z ;;
- : Z.t = -83
# 0x18z ;;
- : Z.t = 24
# -0Xaaz ;;
- : Z.t = -170

# 4294967297z (* 2^32+1 *);;
- : Z.t = 4294967297
# 0x100000001z ;;
- : Z.t = 4294967297
# -4294967297z ;;
- : Z.t = -4294967297
# 18446744073709551617z (* 2^64+1 *);;
- : Z.t = 18446744073709551617
# 0x10000000000000001z ;;
- : Z.t = 18446744073709551617
# -18446744073709551617z ;;
- : Z.t = -18446744073709551617
# 0x8fffffffz ;;
- : Z.t = 2415919103

# 0q ;;
- : Q.t = 0
# 1q ;;
- : Q.t = 1
# -1q ;;
- : Q.t = -1
# 123q ;;
- : Q.t = 123
# -0b010q ;;
- : Q.t = -2
# 0o147q ;;
- : Q.t = 103
# -0O123q ;;
- : Q.t = -83
# 0x18q ;;
- : Q.t = 24
# 0xaaq ;;
- : Q.t = 170

# 4294967297q (* 2^32+1 *);;
- : Q.t = 4294967297
# 0x100000001q ;;
- : Q.t = 4294967297
# -4294967297q ;;
- : Q.t = -4294967297
# 18446744073709551617q (* 2^64+1 *);;
- : Q.t = 18446744073709551617
# 0x10000000000000001q ;;
- : Q.t = 18446744073709551617
# -18446744073709551617q ;;
- : Q.t = -18446744073709551617
# 0x8fffffffq ;;
- : Q.t = 2415919103
```

## Fail
<!-- $MDX version>=4.08 -->
```ocaml
# 0b2z ;;
Line 1, characters 1-5:
Error: Invalid literal 0b2z
# 0O8z ;;
Line 1, characters 1-5:
Error: Invalid literal 0O8z
# 0x12g8z ;;
Line 1, characters 1-8:
Error: Invalid literal 0x12g8z
# 0b2q ;;
Line 1, characters 1-5:
Error: Invalid literal 0b2q
# 0O8q ;;
Line 1, characters 1-5:
Error: Invalid literal 0O8q
# 0x12g8q ;;
Line 1, characters 1-8:
Error: Invalid literal 0x12g8q
```

### Error positions
<!-- $MDX version>=4.08 -->
```ocaml
# let foo = [ Q.neg 0x12.4q ] ;;
Line 1, characters 19-26:
Error: Hexadecimal floating point numbers are not accepted. Please use
       hexadecimal
       integers, or regular floating point
       numbers.
```

# Floats
```ocaml
# 1.z;;
- : Z.t = 1
# 1.2e10z;;
- : Z.t = 12000000000
# -1135.32135e50z;;
- : Z.t = -113532135000000000000000000000000000000000000000000000

# 1.q;;
- : Q.t = 1
# 0.324q;;
- : Q.t = 81/250
# 123.545q;;
- : Q.t = 24709/200
# -1.5e-1q;;
- : Q.t = -3/20
# 1.e-4q;;
- : Q.t = 1/10000
# 1.2e10q;;
- : Q.t = 12000000000
# -1135.32135e50q;;
- : Q.t = -113532135000000000000000000000000000000000000000000000
```

## Fail
<!-- $MDX version>=4.08 -->
```ocaml
# 1.2z;;
Line 1, characters 1-5:
Error: This literal does not fit in an integer. You should use a rational
       number.
# 1.e-4z;;
Line 1, characters 1-7:
Error: This literal does not fit in an integer. You should use a rational
       number.
```
