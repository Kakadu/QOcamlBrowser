OCAML=ocamlfind opt -package unix -g -I `ocamlc -where`/compiler-libs/utils \
	  -I `ocamlc -where`/compiler-libs/typing \
	  misc.cmx \
	  primitive.cmx \
	  config.cmx \
	  ident.cmx \
	  path.cmx \
	  types.cmx \
	  btype.cmx \
	  predef.cmx \
	  clflags.cmx \
	  oprint.cmx \
	  tbl.cmx \
	  consistbl.cmx \
	  subst.cmx \
	  datarepr.cmx \
	  env.cmx \
	  ctype.cmx \
	  printtyp.cmx

.PHONY: all clean

all:
	$(OCAML) -c Asdf.ml
	$(OCAML) -c code.ml
	$(OCAML) -linkpkg -output-obj -o camlcode.o  $(TOPLEVEL) Asdf.cmx code.cmx

test: all
	$(OCAML) -c test.ml 
	$(OCAML) -linkpkg $(TOPLEVEL) code.cmx test.cmx -o test

clean:
	rm *.o *.cmx -f

