; PROGRAM PEMBANDING DUA LUAS PERSEGI PANJANG
; -------------------------------------------
; Anggoa Kelompok :
;  * Andaru Danurdara Wibisana    140810200020
;  * Irfan Kamal                  140810200032
;  * Muhammad Attila An Naufal    140810200048

org 0x100

global start

section .text

; Macro untuk melakukan perkalian bilangan
%macro multiply 2
    mov ax, %1              ; Assign angka pertama ke ax
    mul %2                  ; Kalikan angka kedua dengan angka pada ax (angka pertama)
%endmacro

; Macro untuk print angka desimal
%macro print_num 1
    mov dx, 0               ; Mengosongkan dx
    mov bx, 10              ; Assign nilai 10 sebagai pembagi angka ke bx
    mov cx, 0               ; Mengosongkan cx
    mov ax, %1              ; Assign nilai yang ingin dicetak ke ax

    %%push_to_stack:
    mov dx, 0               ; Kosongkan dx
    div bx                  ; Bagi ax dengan bx
    push dx                 ; Push sisa bagi ke stack
    inc cx                  ; Increment nilai cx
    cmp ax, 0               ; Cek apakah ax sudah habis atau belum
    jne %%push_to_stack     ; Jika belum habis, maka jump ke push_to_stack

    %%cetak:
    mov ah, 2h              ; DOS Interrupt untuk cetak karakter
    pop dx                  ; Pop data top dari stack ke dx
    add dx, 48              ; Tambahkan dengan 48, menyesuaikan dengan simbol angka 6 pada tabel ASCII Code
    int 21h                 ; Interrupt (cetak karakter/angka)
    dec cx                  ; Decrement nilai cx
    jnz %%cetak             ; Jika belum habis, maka jump ke cetak
%endmacro

; Macro untuk print string
%macro print_str 1          
    mov ah, 9h              ; DOS Interrupt untuk cetak string
    mov dx, %1              ; Masukkan string ke dx
    int 21h                 ; Interrupt (cetak string)
%endmacro

start:
    print_str frame         ; Cetak bingkai judul
    print_str title         ; Cetak judul
    print_str frame         ; Cetak bingkai judul

kali_dan_tampilkan:
    push bp                                     ; Save nilai bp
    mov  bp, sp                                 ; Membuat bp menunjuk ke sp
    sub  sp, 8                                  ; Mengalokasikan 4 variabel lokal (8/2 = 4)

    mov word [bp - 2], 5                        ; P1 (Panjang persegi panjang 1) = 5
    mov word [bp - 4], 4                        ; Le1 (Lebar persegi panjang 1) = 4
    mov word [bp - 6], 3                        ; P2 (Panjang persegi panjang 2) = 3
    mov word [bp - 8], 8                        ; Le2 (Lebar persegi panjang 2) = 8

    multiply word [bp - 2], word [bp - 4]       ; Melakukan perkalian nilai P1 dan Le1 dengan macro 'multiply'
    mov [Luas1], ax                             ; Memindahkan hasil perkalian ke variabel Luas1
    multiply word [bp - 6], word [bp - 8]       ; Melakukan perkalian nilai P2 dan Le2 dengan macro 'multiply'
    mov [Luas2], ax                             ; Memindahkan hasil perkalian ke variabel Luas2

bandingkan:
    print_str luas_1        ; Cetak string luas_1
    print_num [Luas1]       ; Cetak value pada variabel Luas1
    print_str luas_2        ; Cetak string luas_2
    print_num [Luas2]       ; Cetak value pada variabel Luas2

    print_str banding1      ; Cetak string banding1
    mov bx, [Luas1]         ; Memindahkan value Luas1 ke bx untuk dibandingkan
    mov cx, [Luas2]         ; Memindahkan value Luas2 ke cx untuk dibandingkan
    cmp bx, cx              ; Membandingkan nilai bx dengan cx
    je sama                 ; Jika bx == cx, jump ke label 'sama'

    cmp bx, cx              ; Membandingkan nilai bx dengan cx
    jg lebih                ; Jika bx > cx, jump ke label 'lebih'

; Apabila dua conditional jump sebelumnya dilewati/tidak terpenuhi, maka program akan masuk label 'kurang'
kurang:
    print_str banding3      ; Cetak string banding3
    jmp close               ; Jump program ke label 'close'

lebih:
    print_str banding2      ; Cetak string banding2
    jmp close               ; Jump program ke label 'close'

sama:
    print_str banding4      ; Cetak string banding4
    jmp close               ; Jump program ke label 'close'

; Label akhir program
close:
    leave                   ; Menghapus variabel lokal dan mengambil bp lama dari stack
    ret                     ; Return dari fungsi sekaligus menutup program

section .data:
frame       db "===========================================", 0xD, 0xA, "$"
title       db "PROGRAM PEMBANDING DUA LUAS PERSEGI PANJANG", 0xD, 0xA, "$"
luas_1      db 0xD, 0xA, "Luas persegi panjang 1 adalah : $"
luas_2      db 0xD, 0xA, "Luas persegi panjang 2 adalah : $"
banding1    db 0xD, 0xA, 0xD, 0xA, "Luas persegi panjang 1 $"
banding2    db "lebih besar dari luas persegi panjang 2.$"
banding3    db "lebih kecil dari luas persegi panjang 2.$"
banding4    db "sama dengan luas persegi panjang 2.$"

section .bss
Luas1       : resb 2    ; Inisialisasi variabel Luas1 2 byte (16 bit)
Luas2       : resb 2    ; Inisialisasi variabel Luas2 2 byte (16 bit)