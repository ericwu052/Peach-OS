	[BITS 32]

	global _start
	global kernel_registers
	extern kernel_main
	
	CODE_SEG equ 0x08
	DATA_SEG equ 0x10
	
_start:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov ebp, 0x200000
	mov esp, ebp

	;; enable the A20 line
	in al, 0x92
	or al, 2
	out 0x92, al

	;; remap the master PIC (Programmable Interrupt Controller)
	mov al, 00010001b
	out 0x20, al		; tell master PIC
	mov al, 0x20		; where master ISR should start
	out 0x21, al

	mov al, 00000001b
	out 0x21, al
	;; end remap of the master PIC

	call kernel_main
	jmp $

kernel_registers:
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov gs, ax
	mov fs, ax
	ret
	
	times 512 - ($ - $$) db 0
