# Zarith-ppx

The `zarith-ppx` package provides literals 
for arbitrary-precision integers and rationals
with the [Zarith library][zarith].
Here are some examples:

```ocaml
# 1z ;;
- : Z.t = 1
# 1.234e40z ;;
- : Z.t = 12340000000000000000000000000000000000000
# 0x18z ;;
- : Z.t = 24
# 1.2q ;;
- : Q.t = 6/5
# 2.45e10q ;;
- : Q.t = 24500000000
# 2.45e-5q ;;
- : Q.t = 49/2000000
# -0O123q ;;
- : Q.t = -83
```

It also raise errors for incorrect literals:
```ocaml
# 1.234e2z ;;
Error: This literal does not fit in an integer.
```

This package depends on vanilla Zarith, but the generated code is compatible with any cross-compiled version of Zarith such as `zarith-freestanding` and `zarith-xen`.

zarith: https://github.com/ocaml/Zarith
