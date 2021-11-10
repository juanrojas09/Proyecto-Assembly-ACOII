.globl app
app:
	//---------------- Inicialización GPIO --------------------

	mov w20, PERIPHERAL_BASE + GPIO_BASE     // Dirección de los GPIO.		
	
	// Configurar GPIO 17 como input:
	mov X21,#0
	str w21,[x20,GPIO_GPFSEL1] 		// Coloco 0 en Function Select 1 (base + 4)   	
	
	//---------------- Main code --------------------
	// X0 contiene la dirección base del framebuffer (NO MODIFICAR)
	
	 mov w16, 0xFFE0    // Amarillo
    mov w17, 0xF81F     // Rosa
    mov w18, 0xF800    // Rojo
	
	add x10, x0, 0		// X10 contiene la dirección base del framebuffer
loop2:
	mov x2,512         	// Tamaño en Y
loop1:
        mov w3, 0xF800    	// 0xF800 = ROJO
	mov x11, 1		// case
	mov x1,512         	// Tamaño en X
	//mov x13, 63		// contador para color, arranco del maximo, el verde tiene mas bits, x eso el cont mas grande
	
case:
	cmp x11, 1
	beq RA
	cmp x11, 2
	beq AV
	cmp x11, 3
	beq VC
	cmp x11, 4
	beq CA
	cmp x11, 5
	beq AR
	cmp x11, 6
	beq RR
	b loop0
	
	
	
RA:
	cmp w3,w16    // pasar de rojo a amarillo
	beq incremento
	add w3,w3,#0x0020
	
	b loop0
AV:
    cmp w3,0x07E0 //verde puro
	beq incremento
	sub w3,w3,0x0800 //decremento el rojo
	b loop0
	
VC:
        cmp w3,0x07FF
	beq incremento 
	add w3,w3,0x0001 
	b loop0

CA:
        cmp w3,0x001F
	beq incremento
	sub w3,w3,0x0020
	b loop0
AR:
        cmp w3,w17 //comparo directamente con el registro, porque a ltener los 32 bits, no funcionaba x un tema de limite
	beq incremento
        add w3,w3,0x0800
	b loop0
RR:
cmp w3,w18
beq incremento
sub w3,w3,0x0001    // pasar de rosa a rojo
b loop0


incremento:
add x11,x11,1
cmp x11,7
bne case
mov x11,1
b case	
	
loop0:
	sturh w3,[x10]	   	// Setear el color del pixel N
	add x10,x10,2	   	// Siguiente pixel
	sub x1,x1,1	   		// Decrementar el contador X
	cbnz x1,case	   	// Si no terminó la fila, saltar
	sub x2,x2,1	   		// Decrementar el contador Y
	cbnz x2,loop1  	// Si no es la última fila, saltar
	
	// --- Delay loop ---
	//movz x15, 0x10, lsl #16
//delay1: 
//	sub x15,x15,#1
//	cbnz x15, delay1
	// ------------------
		
	//bl inputRead		// Leo el GPIO17 y lo guardo en x21
	//mov w3, 0x001F    	// 0x001F = AZUL	
	//add x10, x0, 0		// X10 contiene la dirección base del framebuffer
	//cbz X22, loop2
	//mov w3, 0x07E0    	// 0x07E0 = VERDE			
	//b loop2
	
	// --- Infinite Loop ---	
InfLoop: 
	b InfLoop