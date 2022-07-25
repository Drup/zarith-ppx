(lang dune 3.0)
(name zarith-ppx)
(using mdx 0.2)

(generate_opam_files true)

(source (github Drup/zarith-ppx))
(license ISC)
(authors "Gabriel Radanne")
(maintainers "Gabriel Radanne <drupyog@zoho.com>")

(package
 (name zarith-ppx)
 (synopsis "Literals for Zarith's arbitrary-precision integers and rationals")
 (description "The Zarith library implements arithmetic and logical operations over
arbitrary-precision integers. Zarith-ppx add support for literals
of the form '13z' and '1.5q'.")
 (tags (ppx zarith))
 (depends
  ppxlib
  zarith
  (mdx (and :with-test (>= 1.9.0))))) ; according to dune docs: "Version 0.2 of the stanza requires mdx 1.9.0."
