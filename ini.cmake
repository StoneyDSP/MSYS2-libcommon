cmake_minimum_required(VERSION 3.8...3.27 FATAL_ERROR)

#[===[.md

    MIT License

    Copyright (c) 2017 vector-of-bool <vectorofbool@gmail.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

#]===]
macro(convert_to_hex INPUT_FILE OUTPUT_FILE)
	# Read in the digits
	file(READ "${INPUT_FILE}" bytes HEX)
	# Format each pair into a character literal. Heuristics seem to favor doing
	# the conversion in groups of five for fastest conversion
	string(REGEX REPLACE "(..)(..)(..)(..)(..)" "\"\\\\x\\1\" \"\\\\x\\2\" \"\\\\x\\3\" \"\\\\x\\4\" \"\\\\x\\5\" " chars "${bytes}")
	# Since we did this in groups, we have some leftovers to clean up
	string(LENGTH "${bytes}" n_bytes2)
	math(EXPR n_bytes "${n_bytes2} / 2")
	math(EXPR remainder "${n_bytes} % 5") # <-- '5' is the grouping count from above
	set(cleanup_re "$")
	set(cleanup_sub )
	while(remainder)
		set(cleanup_re "(..)${cleanup_re}")
		set(cleanup_sub "\"\\\\x\\${remainder}\" ${cleanup_sub}")
		math(EXPR remainder "${remainder} - 1")
	endwhile()
	if(NOT cleanup_re STREQUAL "$")
		string(REGEX REPLACE "${cleanup_re}" "${cleanup_sub}" chars "${chars}")
	endif()
	string(CONFIGURE [[
#define @INPUT_FILE@ @chars@ 0
const char* file_array = @chars@ 0;
extern const char* const @SYMBOL@_begin = file_array;
extern const char* const @SYMBOL@_end = file_array + @n_bytes@;
]] code)

	file(WRITE "${OUTPUT_FILE}" "${code}")
	# Exit from the script. Nothing else needs to be processed
endmacro()



# set(PM_INTEGRITY "SHA1")

# set(PM_INTEGRITY_TYPES)
# list(APPEND PM_INTEGRITY_TYPES
# 	"MD5" # Message-Digest Algorithm 5, RFC 1321
# 	"SHA1" # US Secure Hash Algorithm 1, RFC 3174
# 	"SHA224"
# 	"SHA256"
# 	"SHA384"
# 	"SHA512"
# 	# 'SHA3_*' requires CMake v3.8 or later
# 	"SHA3_224"
# 	"SHA3_256"
# 	"SHA3_384"
# 	"SHA3_512"
# )

# PM_INI_H
set(PM_INI_H)
set(PM_INI_H_HEX)
set(PM_INI_H_HASH)
file(READ "${CMAKE_CURRENT_LIST_DIR}/ini.h" PM_INI_H)
file(READ "${CMAKE_CURRENT_LIST_DIR}/ini.h" PM_INI_H_HEX HEX)
file(SHA1 "${CMAKE_CURRENT_LIST_DIR}/ini.h" PM_INI_H_HASH)

# PM_INI_C
set(PM_INI_C)
set(PM_INI_C_HEX)
set(PM_INI_C_HASH)
file(READ "${CMAKE_CURRENT_LIST_DIR}/ini.c" PM_INI_C)
file(READ "${CMAKE_CURRENT_LIST_DIR}/ini.c" PM_INI_C_HEX HEX)
file(SHA1 "${CMAKE_CURRENT_LIST_DIR}/ini.c" PM_INI_C_HASH)

convert_to_hex(
	# INPUT_FILE
	"${CMAKE_CURRENT_LIST_DIR}/ini.h"
	# OUTPUT_FILE
	"ini_hex_x.c"
)

# string(SHA1 PM_INI_HASH "${PM_INI_H_HASH}${PM_INI_C_HASH}")

# file(WRITE "ini.hex" "")
# file(APPEND "ini.hex" "${PM_INI_H_HEX}")
# file(APPEND "ini.hex" "${PM_INI_C_HEX}")

# file(WRITE "ini.hash" "")
# file(APPEND "ini.hash" "${PM_INI_HASH}")
