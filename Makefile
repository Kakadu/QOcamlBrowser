GCC=g++ -c -m64 -pipe -O2 -Wall -W -D_REENTRANT -DQT_WEBKIT -DQT_NO_DEBUG -DQT_DECLARATIVE_LIB -DQT_GUI_LIB -DQT_CORE_LIB -DQT_SHARED -I/usr/share/qt4/mkspecs/linux-g++-64 -I. -I/usr/include/qt4/QtCore -I/usr/include/qt4/QtGui -I/usr/include/qt4/QtDeclarative -I/usr/include/qt4 -Iqmlapplicationviewer -I.  
MOCQT4=/usr/bin/moc-qt4 -DQT_WEBKIT -DQT_NO_DEBUG -DQT_DECLARATIVE_LIB -DQT_GUI_LIB -DQT_CORE_LIB -DQT_SHARED -I/usr/share/qt4/mkspecs/linux-g++-64 -I. -I/usr/include/qt4/QtCore -I/usr/include/qt4/QtGui -I/usr/include/qt4/QtDeclarative -I/usr/include/qt4 -Iqmlapplicationviewer -I. 

.SUFFIXES: .cpp .h .o
.PHONY: all

MOCFILES=moc_qmlapplicationviewer.cpp moc_dataobject.cpp  
CPPOBJECTS=main.o dataobject.o moc_dataobject.o \
		  qmlapplicationviewer.o moc_qmlapplicationviewer.o

all: $(MOCFILES) $(CPPOBJECTS)
	g++ -m64 -Wl,-O1 -o QOcamlBrowser main.o dataobject.o qmlapplicationviewer.o moc_qmlapplicationviewer.o moc_dataobject.o    -L/usr/lib/x86_64-linux-gnu -lQtDeclarative -lQtGui -lQtCore -lpthread 

moc_%.cpp: %.h
	$(MOCQT4) $< > $@

.cpp.o:
	$(GCC) -c $<

clean:
	rm -f moc_*.cpp *.o

