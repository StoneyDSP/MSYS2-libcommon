#if defined(__cplusplus)
extern "C" {
#endif

#if !defined(HAS_STRNDUP)
#	define HAS_STRNDUP @STRNDUP@
#endif

#if !defined(HAS_STRNLEN)
#	define HAS_STRNLEN @STRNLEN@
#endif

#if !defined(HAS_STRSEP)
#	define HAS_STRSEP @STRSEP@
#endif

/** HAVE_STRNDUP */
#if !defined(HAVE_STRNDUP)
#	define HAVE_STRNDUP 0
#elif (HAVE_STRNDUP + 0) != 0 || (1 - HAVE_STRNDUP - 1) == 2
#	define HAVE_STRNDUP 1
#else
#	define HAVE_STRNDUP 0
#endif

/** HAVE_STRLEN */
#if !defined(HAVE_STRNLEN)
#	define HAVE_STRNLEN 0
#elif (HAVE_STRNLEN + 0) != 0 || (1 - HAVE_STRNLEN - 1) == 2
#	define HAVE_STRNLEN 1
#else
#	define HAVE_STRNLEN 0
#endif

/** HAVE_STRSEP */
#if !defined(HAVE_STRSEP)
#	define HAVE_STRSEP 0
#elif (HAVE_STRSEP + 0) != 0 || (1 - HAVE_STRSEP - 1) == 2
#	define HAVE_STRSEP 1
#else
#	define HAVE_STRSEP 0
#endif

#if defined(__cplusplus)
}
#endif
