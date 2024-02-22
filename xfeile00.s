; Vernamova sifra na architekture DLX
; Marcel Feiler xfeile00

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xfeile00"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 

main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani
	sub r3,r3,r3
	sub r5, r5, r5
	addi r13, r0, 1
	lb r21, login(r13);prvy znak
	addi r13, r13, 1
	lb r3, login(r13) ;druhy znak
	addi r21, r21, -96 ; value prvej sifrovaneho znaku +
	addi r3, r3, -96  ; value druheho sifr znaku -

	

	xor r13,r13,r13
	
cycle:
	
	lb r5, login(r2) ;nacita aktualny znak indexu
	andi r12, r2, 1 ;rozhoda o parite
	bnez r12, neparne
	nop
	nop
	add r5, r5, r21 ;pricitanie v pripade parneho
	j dalej
	nop	
	nop

neparne:
	sub r5, r5, r3 ;odcitanie podla sifry
	j dalej
	nop 
	nop
	
dalej:
	sgti r12, r5, 122
	bnez r12, zmena2
	nop
	nop
	
	slti r12, r5, 97
	bnez r12, zmena1
	nop
	nop

	j pokrac
	nop
	nop
zmena1: ;pretieka zdola
	addi r5, r5, 26  
	j pokrac
	nop
	nop

zmena2: ;pretieka zhora
	addi r5, r5, -26
	j pokrac
	nop
	nop

pokrac:
	slti r12, r5, 97
	bnez r12, end
	nop
	nop
	sb cipher(r2),r5
	addi r2, r2, 1 ;zvysenie indexu
	
	j cycle
	nop
	nop
	


end:
	sb cipher(r2), r0    ; znak NULL nakoniec
	addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
