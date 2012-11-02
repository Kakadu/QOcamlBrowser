OCAML=ocamlfind opt -package unix -I `ocamlc -where`/compiler-libs/utils \
	  -I `ocamlc -where`/compiler-libs/typing \
	  `ocamlc -where`/compiler-libs/utils/misc.cmx \
	  `ocamlc -where`/compiler-libs/typing/primitive.cmx \
	  `ocamlc -where`/compiler-libs/utils/config.cmx \
	  `ocamlc -where`/compiler-libs/typing/ident.cmx \
	  `ocamlc -where`/compiler-libs/typing/path.cmx \
	  `ocamlc -where`/compiler-libs/typing/types.cmx \
	  `ocamlc -where`/compiler-libs/typing/btype.cmx \
	  `ocamlc -where`/compiler-libs/typing/predef.cmx \
	  `ocamlc -where`/compiler-libs/utils/clflags.cmx \
	  `ocamlc -where`/compiler-libs/typing/oprint.cmx \
	  `ocamlc -where`/compiler-libs/utils/tbl.cmx \
	  `ocamlc -where`/compiler-libs/utils/consistbl.cmx \
	  `ocamlc -where`/compiler-libs/typing/subst.cmx \
	  `ocamlc -where`/compiler-libs/typing/datarepr.cmx \
	  `ocamlc -where`/compiler-libs/typing/env.cmx \
	  `ocamlc -where`/compiler-libs/typing/ctype.cmx \
	  `ocamlc -where`/compiler-libs/typing/printtyp.cmx \

.PHONY: all clean

all:
	$(OCAML) -c code.ml
	$(OCAML) -linkpkg -output-obj -o camlcode.o  $(TOPLEVEL) code.cmx

test: all
	$(OCAML) -c test.ml 
	$(OCAML) -linkpkg $(TOPLEVEL) code.cmx test.cmx -o test

clean:
	rm *.o *.cmx -f

