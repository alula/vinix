module initramfs

import lib
import stivale2
import fs
import stat
import memory

struct USTARHeader {
	name       [100]byte
	mode       [8]byte
	uid        [8]byte
	gid        [8]byte
	size       [12]byte
	mtime      [12]byte
	checksum   [8]byte
	filetype   byte
	link_name  [100]byte
	signature  [6]byte
	version    [2]byte
	owner      [32]byte
	group      [32]byte
	device_maj [8]byte
	device_min [8]byte
	prefix     [155]byte
}

enum USTARFileType {
	regular_file  = 0x30
	hard_link     = 0x31
	sym_link      = 0x32
	char_dev      = 0x33
	block_dev     = 0x34
	directory     = 0x35
	fifo          = 0x36
	gnu_long_path = 0x4c
}

fn octal_to_int(s string) u64 {
	mut ret := u64(0)
	for c in s {
		ret *= 8
		ret += u64(c) - 0x30
	}
	return ret
}

fn C.string_free(&string)

[manualfree]
pub fn init(modules_tag stivale2.ModulesTag) {
	if modules_tag.count < 1 {
		panic('No initramfs')
	}

	mut modules := unsafe { &stivale2.Module(&modules_tag.modules) }

	initramfs_begin := unsafe { modules[0].begin }
	initramfs_size  := unsafe { modules[0].end - modules[0].begin }

	println('initramfs: Address: 0x${voidptr(initramfs_begin):x}')
	println('initramfs: Size:    ${u32(initramfs_size):u}')

	print('initramfs: Unpacking...')

	mut name_override := ''
	mut current_header := &USTARHeader(0)
	unsafe { current_header = &USTARHeader(initramfs_begin) }

	for {
		sig := unsafe { tos(&current_header.signature[0], 5) }
		if sig != 'ustar' {
			break
		}

		name := if name_override == '' {
			unsafe { tos2(&current_header.name[0]) }
		} else { 
			name_override
		}
		link_name := unsafe { tos2(&current_header.link_name[0]) }
		size := unsafe { octal_to_int(tos2(&current_header.size[0])) }
		mode := unsafe { octal_to_int(tos2(&current_header.mode[0])) }
		
		name_override = ''
		if name == './' {
			unsafe { goto next }
		}

		match USTARFileType(current_header.filetype) {
			.gnu_long_path {
				// limit for safety
				if size >= 65536 {
					panic('initramfs: long file name exceeds 65536 characters.')
				}

				name_override = unsafe { tos(voidptr(u64(current_header) + 512), int(size)) }
			}
			.directory {
				fs.create(vfs_root, name, int(mode) | stat.ifdir) or {
					panic('initramfs: failed to create directory ${name}')
				}
			}
			.regular_file {
				new_node := fs.create(vfs_root, name, int(mode) | stat.ifreg) or {
					panic('initramfs: failed to create file ${name}')
				}
				mut new_resource := new_node.resource
				buf := voidptr(u64(current_header) + 512)
				new_resource.write(0, buf, 0, size) or {
					panic('initramfs: failed to write file ${name}')
				}
			}
			.sym_link {
				fs.symlink(vfs_root, link_name, name) or {
					panic('initramfs: failed to create symlink ${name}')
				}
			}
			else {}
		}

next:
		memory.pmm_free(voidptr(u64(current_header) - higher_half),
						(u64(512) + lib.align_up(size, 512)) / page_size)

		current_header = &USTARHeader(size_t(current_header) + size_t(512) + size_t(lib.align_up(size, 512)))
	}

	print('\ninitramfs: Done.\n')
}

