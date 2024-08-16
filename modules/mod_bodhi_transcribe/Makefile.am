include $(top_srcdir)/build/modmake.rulesam
MODNAME=mod_bodhi_transcribe

mod_LTLIBRARIES = mod_bodhi_transcribe.la
mod_bodhi_transcribe_la_SOURCES  = mod_bodhi_transcribe.c dg_transcribe_glue.cpp audio_pipe.cpp parser.cpp
mod_bodhi_transcribe_la_CFLAGS   = $(AM_CFLAGS)
mod_bodhi_transcribe_la_CXXFLAGS = $(AM_CXXFLAGS) -std=c++11
mod_bodhi_transcribe_la_LIBADD   = $(switch_builddir)/libfreeswitch.la
mod_bodhi_transcribe_la_LDFLAGS  = -avoid-version -module -no-undefined -shared `pkg-config --libs libwebsockets` 
