# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/wcsng-23/Frederik/beam_armor/srsRAN

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/wcsng-23/Frederik/beam_armor/srsRAN/build

# Include any dependencies generated for this target.
include srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/depend.make

# Include the progress variables for this target.
include srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/progress.make

# Include the compile flags for this target's objects.
include srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/flags.make

srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.o: srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/flags.make
srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.o: ../srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/wcsng-23/Frederik/beam_armor/srsRAN/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.o"
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build/srsgnb/src/stack/mac/test && /usr/bin/ccache /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.o -c /home/wcsng-23/Frederik/beam_armor/srsRAN/srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests.cc

srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.i"
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build/srsgnb/src/stack/mac/test && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/wcsng-23/Frederik/beam_armor/srsRAN/srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests.cc > CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.i

srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.s"
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build/srsgnb/src/stack/mac/test && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/wcsng-23/Frederik/beam_armor/srsRAN/srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests.cc -o CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.s

# Object files for target sched_nr_dci_utilities_tests
sched_nr_dci_utilities_tests_OBJECTS = \
"CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.o"

# External object files for target sched_nr_dci_utilities_tests
sched_nr_dci_utilities_tests_EXTERNAL_OBJECTS =

srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/sched_nr_dci_utilities_tests.cc.o
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/build.make
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: srsgnb/src/stack/mac/libsrsgnb_mac.a
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: lib/src/common/libsrsran_common.a
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: lib/src/asn1/librrc_nr_asn1.a
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: lib/src/asn1/libasn1_utils.a
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: srsenb/src/stack/mac/common/libsrsenb_mac_common.a
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: lib/src/mac/libsrsran_mac.a
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: lib/src/common/libsrsran_common.a
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: lib/src/phy/libsrsran_phy.a
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: /usr/lib/x86_64-linux-gnu/libfftw3f.so
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: lib/src/support/libsupport.a
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: lib/src/srslog/libsrslog.a
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: /usr/lib/x86_64-linux-gnu/libmbedcrypto.so
srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests: srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/wcsng-23/Frederik/beam_armor/srsRAN/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable sched_nr_dci_utilities_tests"
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build/srsgnb/src/stack/mac/test && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/sched_nr_dci_utilities_tests.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/build: srsgnb/src/stack/mac/test/sched_nr_dci_utilities_tests

.PHONY : srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/build

srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/clean:
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build/srsgnb/src/stack/mac/test && $(CMAKE_COMMAND) -P CMakeFiles/sched_nr_dci_utilities_tests.dir/cmake_clean.cmake
.PHONY : srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/clean

srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/depend:
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/wcsng-23/Frederik/beam_armor/srsRAN /home/wcsng-23/Frederik/beam_armor/srsRAN/srsgnb/src/stack/mac/test /home/wcsng-23/Frederik/beam_armor/srsRAN/build /home/wcsng-23/Frederik/beam_armor/srsRAN/build/srsgnb/src/stack/mac/test /home/wcsng-23/Frederik/beam_armor/srsRAN/build/srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : srsgnb/src/stack/mac/test/CMakeFiles/sched_nr_dci_utilities_tests.dir/depend
