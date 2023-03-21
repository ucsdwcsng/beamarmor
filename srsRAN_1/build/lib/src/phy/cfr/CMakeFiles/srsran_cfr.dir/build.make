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
include lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/depend.make

# Include the progress variables for this target.
include lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/progress.make

# Include the compile flags for this target's objects.
include lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/flags.make

lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/cfr.c.o: lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/flags.make
lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/cfr.c.o: ../lib/src/phy/cfr/cfr.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/wcsng-23/Frederik/beam_armor/srsRAN/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/cfr.c.o"
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build/lib/src/phy/cfr && /usr/bin/ccache /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/srsran_cfr.dir/cfr.c.o   -c /home/wcsng-23/Frederik/beam_armor/srsRAN/lib/src/phy/cfr/cfr.c

lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/cfr.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/srsran_cfr.dir/cfr.c.i"
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build/lib/src/phy/cfr && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/wcsng-23/Frederik/beam_armor/srsRAN/lib/src/phy/cfr/cfr.c > CMakeFiles/srsran_cfr.dir/cfr.c.i

lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/cfr.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/srsran_cfr.dir/cfr.c.s"
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build/lib/src/phy/cfr && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/wcsng-23/Frederik/beam_armor/srsRAN/lib/src/phy/cfr/cfr.c -o CMakeFiles/srsran_cfr.dir/cfr.c.s

srsran_cfr: lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/cfr.c.o
srsran_cfr: lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/build.make

.PHONY : srsran_cfr

# Rule to build all files generated by this target.
lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/build: srsran_cfr

.PHONY : lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/build

lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/clean:
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build/lib/src/phy/cfr && $(CMAKE_COMMAND) -P CMakeFiles/srsran_cfr.dir/cmake_clean.cmake
.PHONY : lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/clean

lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/depend:
	cd /home/wcsng-23/Frederik/beam_armor/srsRAN/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/wcsng-23/Frederik/beam_armor/srsRAN /home/wcsng-23/Frederik/beam_armor/srsRAN/lib/src/phy/cfr /home/wcsng-23/Frederik/beam_armor/srsRAN/build /home/wcsng-23/Frederik/beam_armor/srsRAN/build/lib/src/phy/cfr /home/wcsng-23/Frederik/beam_armor/srsRAN/build/lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : lib/src/phy/cfr/CMakeFiles/srsran_cfr.dir/depend

