/*
 * m681 ABI guards: compile-time checks for the patched
 * hardware/libhardware/include/hardware/audio.h, which keeps the pre-P layout
 * of struct audio_hw_device expected by audio.primary.mt6755.so. A wrong
 * layout exports the same symbols, so only a compile-time check catches it.
 *
 * Built as part of m681_nvram_wifi_repair so that it is always compiled.
 */

#include <stddef.h>
#include <hardware/audio.h>

/*
 * Portable static assertion: _Static_assert is C11, this module builds as
 * gnu99, so fall back to a negative-size array typedef.
 */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
#define M681_ABI_ASSERT(cond, name, msg) _Static_assert(cond, msg)
#else
#define M681_ABI_ASSERT(cond, name, msg) typedef char name[(cond) ? 1 : -1]
#endif

/*
 * GUARD 1 — nothing may be inserted between close_input_stream and dump.
 *
 * Android P inserted get_microphones there, shifting every later function
 * pointer by one slot. audio.primary.mt6755.so is a pre-P blob, so the
 * framework then called the blob's create_audio_patch through the
 * get_master_mute slot. The patched audio.h moves get_microphones to the
 * struct tail.
 *
 * Offsets (arm64 / arm32):
 *   close_input_stream  232 / 120
 *   dump                240 / 124
 *   create_audio_patch  264 / 136
 *   get_microphones     296 / 152   (last member)
 *
 * Asserted as a relation, so it holds on both arches.
 */
M681_ABI_ASSERT(
    offsetof(struct audio_hw_device, dump) ==
        offsetof(struct audio_hw_device, close_input_stream) + sizeof(void *),
    M681_ABI_BROKEN_something_inserted_between_close_input_stream_and_dump,
    "audio_hw_device: a member was inserted between close_input_stream and "
    "dump. The pre-P vendor blob ABI is broken and audioserver will SIGSEGV. "
    "The local fix to hardware/libhardware/include/hardware/audio.h has "
    "probably been reverted by a repo sync. "
    "See docs/M681_REQUIRED_LOCAL_PATCHES.md entry C.");

/*
 * GUARD 2 — get_microphones must remain past the last legacy member, i.e. at
 * the struct tail, which is where our fix puts it.
 */
M681_ABI_ASSERT(
    offsetof(struct audio_hw_device, get_microphones) >
        offsetof(struct audio_hw_device, set_audio_port_config),
    M681_ABI_BROKEN_get_microphones_moved_out_of_the_struct_tail,
    "audio_hw_device: get_microphones is no longer at the struct tail. "
    "The pre-P vendor blob ABI is broken. "
    "See docs/M681_REQUIRED_LOCAL_PATCHES.md entry C.");
