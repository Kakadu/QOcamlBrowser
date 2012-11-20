GCC=g++ -m64 -pipe -O2 -Wall -W -D_REENTRANT -DQT_WEBKIT -DQT_NO_DEBUG -DQT_DECLARATIVE_LIB -DQT_GUI_LIB -DQT_CORE_LIB -I/usr/share/qt4/mkspecs/linux-g++-64 -I. `pkg-config --cflags QtDeclarative` -I`ocamlc -where` -I.  
GCC=g++ -g -I/usr/share/qt4/mkspecs/linux-g++-64 `pkg-config --cflags QtDeclarative` -I`ocamlfind c -where`

MOCQT4=/usr/bin/moc-qt4 -DQT_WEBKIT -DQT_NO_DEBUG -DQT_DECLARATIVE_LIB -DQT_GUI_LIB -DQT_CORE_LIB -DQT_SHARED -I/usr/share/qt4/mkspecs/linux-g++-64 -I. -I/usr/include/qt4/QtCore -I/usr/include/qt4/QtGui -I/usr/include/qt4/QtDeclarative -I/usr/include/qt4 -I`ocamlc -where` -I. 

.SUFFIXES: .cpp .h .o
.PHONY: all
CPP_LOGIC_CLASS=Asdf

MOCFILES=moc_qmlapplicationviewer.cpp  moc_$(CPP_LOGIC_CLASS).cpp  
CPPOBJECTS=main.o qmlapplicationviewer.o moc_qmlapplicationviewer.o \
	$(CPP_LOGIC_CLASS).o moc_$(CPP_LOGIC_CLASS).o
	

all: kamlo $(MOCFILES) $(CPPOBJECTS)
	g++ -m64 -Wl,-O1 -o QOcamlBrowser $(CPPOBJECTS) \
	-L/usr/lib/x86_64-linux-gnu -lQtDeclarative -lQtGui -lQtCore -lpthread \
	ocaml/camlcode.o -L/usr/lib/ocaml/ -lunix -lasmrun

kamlo:
	$(MAKE) --no-print-directory -C ocaml all

moc_%.cpp: %.h
	$(MOCQT4) $< > $@

.cpp.o:
	$(GCC) -c $<

clean:
	rm -f moc_*.cpp *.o

