global start ; makes 'start' available outside this file

section .text
BITS 32
start:
	mov word [0xb8000], 0x0248 ; H
	mov word [0xb8002], 0x0265 ; e
	mov word [0xb8004], 0x0269 ; l
	mov word [0xb8006], 0x0269 ; l
	mov word [0xb8008], 0x026f ; o
	mov word [0xb800a], 0x0220 ; 
	mov word [0xb800c], 0x0257 ; W
	mov word [0xb800e], 0x026f ; o
	mov word [0xb8010], 0x0272 ; r
	mov word [0xb8012], 0x026c ; l
	mov word [0xb8014], 0x0264 ; d
	mov word [0xb8016], 0x0221 ; !
	hlt ; halt command
