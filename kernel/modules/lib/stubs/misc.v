module stubs

import lib

[export: '__ctype_tolower_loc']
pub fn ctype_tolower_loc() &&int {
	lib.kpanic(voidptr(0), c'__ctype_tolower_loc is a stub')
}


[export: '__ctype_toupper_loc']
pub fn ctype_toupper_loc() &&int {
	lib.kpanic(voidptr(0), c'__ctype_toupper_loc is a stub')
}

[export: 'exit']
[noreturn]
pub fn kexit(code int) {
	lib.kpanic(voidptr(0), c'Kernel has called exit()')
}

[export: 'qsort']
pub fn qsort(ptr voidptr, count u64, size u64, comp fn(const_a &C.void, const_b &C.void) int) {
	lib.kpanic(voidptr(0), c'qsort is a stub')
}