(lang dune 2.7)
(generate_opam_files true)

(package
  (name eos)
  (version 0.1.0)
  (bug_reports "https://github.com/maiste/eos/issues")
  (source (github maiste/eos))
  (license MIT)
  (authors
    "Étienne Marais <etienne@maiste.fr>"
    "Xavier Durand <xavier75013@gmail.com>")
  (maintainers "Étienne Marais <etienne@maiste.fr>")
  (synopsis "A configurable header manager.")
  (description "\| Eos is a simple header manager for your projects. It allows
               "\| you to manage header in one single JSON file and automatize
               "\| many features.
  )
  (depends
    (ocaml (>= 4.08.0))
    (ocamlformat :dev)
    (odoc :with-doc)
    (bisect_ppx :with-test)
    cmdliner
    (alcotest :with-test)
    ezjsonm
    mustache
    fmt
    )
  )
