.data
menu: .asciiz "\n1. Menu de Locais\n2. Gerar Rotas\n3. Sair\n"
      
locais: .asciiz "1. Parque Vicentina Aranha\n2. DCTA - Instituto de Aeronautica\n3. Shopping Colinas\n4. Observatorio Astronomico\n"

transportes: .asciiz "\nMeios de transporte disponiveis:\n1. Carro\n2. Onibus\n3. Bicicleta\n4. A pe\n"

# Distancia em km (matriz 4x4)
distancias: .word 0, 5, 3, 8  # Distancias do local 1
            .word 5, 0, 7, 4  # Distancias do local 2
            .word 3, 7, 0, 6  # Distancias do local 3
            .word 8, 4, 6, 0  # Distancias do local 4

# Tempos em minutos por carro (matriz 4x4)
tempos_carro: .word 0, 10, 6, 16    # Tempos do local 1
              .word 10, 0, 14, 8    # Tempos do local 2
              .word 6, 14, 0, 12    # Tempos do local 3
              .word 16, 8, 12, 0    # Tempos do local 4

# Tempos em minutos por onibus (matriz 4x4)
tempos_onibus: .word 0, 25, 15, 35    # Tempos do local 1
               .word 25, 0, 30, 20    # Tempos do local 2
               .word 15, 30, 0, 28    # Tempos do local 3
               .word 35, 20, 28, 0    # Tempos do local 4

# Tempos em minutos por bicicleta (matriz 4x4)
tempos_bike: .word 0, 20, 12, 32    # Tempos do local 1
             .word 20, 0, 28, 16    # Tempos do local 2
             .word 12, 28, 0, 24    # Tempos do local 3
             .word 32, 16, 24, 0    # Tempos do local 4

# Tempos em minutos a pe (matriz 4x4)
tempos_pe: .word 0, 60, 36, 96     # Tempos do local 1
           .word 60, 0, 84, 48     # Tempos do local 2
           .word 36, 84, 0, 72     # Tempos do local 3
           .word 96, 48, 72, 0     # Tempos do local 4

grafo: .word 0, 1, 1, 0    # Vertice 1: conectado com 2 e 3
       .word 0, 0, 1, 1    # Vertice 2: conectado com 3 e 4
       .word 0, 0, 0, 1    # Vertice 3: conectado com 4
       .word 0, 0, 0, 0    # Vertice 4: conectado com ninguem

visitados: .word 0, 0, 0, 0  # Array para marcar vertices visitados
caminho: .word 0:10          # Array para armazenar o caminho atual (max 10 vertices)
tam_caminho: .word 0         # Tamanho atual do caminho
contador_caminhos: .word 0    # Contador para número de caminhos encontrados
msg_caminhos: .asciiz "\nRota #"
dois_pontos: .asciiz ": "

prompt_inicio: .asciiz "\nInsira o numero do local de inicio (1-4): "
prompt_destino: .asciiz "Insira o numero do local de destino (1-4): "
prompt_transporte: .asciiz "Escolha o meio de transporte (1-4): "
resultado: .asciiz "\nDistancia em km: "
separador: .asciiz "\nTempo estimado em minutos: "
erro_local: .asciiz "\nErro: Por favor insira numeros entre 1 e 4 para os locais.\n"
erro_transporte: .asciiz "\nErro: Por favor insira numeros entre 1 e 4 para o transporte.\n"
enter: .asciiz "\n"
msg_caminho: .asciiz "\nCaminho encontrado: "
separador2: .asciiz " -> "
saida_distancia: .asciiz "\nDistancia em km: "
saida_tempo: .asciiz "\nTempo estimado em minutos: "
tchau: .asciiz "\nAté a próxima vez!\n"

local1: .asciiz "Parque Vicentina Aranha"
local2: .asciiz "DCTA - Instituto de Aeronáutica"
local3: .asciiz "Shopping Colinas"
local4: .asciiz "Observatorio Astronomico"

.text
.globl main

main:
    mostra_menu:
        li $v0, 4
        la $a0, menu
        syscall

        li $v0, 5
        syscall
        move $t0, $v0

        beq $t0, 1, print_locais
        beq $t0, 2, input_inicio
        beq $t0, 3, exit
        
print_locais:
    li $v0, 4
    la $a0, locais
    syscall

    j mostra_menu

input_inicio:
    # Resetar contador de caminhos
    la $t0, contador_caminhos
    sw $zero, ($t0)
    
    # Solicitar local de inicio
    li $v0, 4
    la $a0, prompt_inicio
    syscall

    li $v0, 5
    syscall
    move $s0, $v0
    
    blt $s0, 1, erro_input_local
    bgt $s0, 4, erro_input_local

input_destino:
    li $v0, 4
    la $a0, prompt_destino
    syscall

    li $v0, 5
    syscall
    move $s1, $v0
    
    blt $s1, 1, erro_input_local
    bgt $s1, 4, erro_input_local

input_transporte:
    la $a0, transportes
    li $v0, 4
    syscall

    la $a0, prompt_transporte
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $s4, $v0

    blt $s4, 1, erro_input_transporte
    bgt $s4, 4, erro_input_transporte
    
    # Inicializar busca
    jal reset_visitados
    
    # Ajustar indices para 0 based
    addi $s0, $s0, -1
    addi $s1, $s1, -1
    
    # Iniciar DFS
    move $a0, $s0
    move $a1, $s1
    li $a2, 0
    jal dfs

    j mostra_menu

dfs:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    
    la $t0, visitados
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    li $t2, 1
    sw $t2, ($t0)
    
    la $t0, caminho
    sll $t1, $s2, 2
    add $t0, $t0, $t1
    sw $s0, ($t0)
    
    addi $t2, $s2, 1
    la $t0, tam_caminho
    sw $t2, ($t0)
    
    beq $s0, $s1, imprimir_caminho
    
    li $s3, 0
    
loop_vizinhos:
    beq $s3, 4, fim_loop_vizinhos
    
    la $t0, grafo
    mul $t1, $s0, 4
    add $t1, $t1, $s3
    sll $t1, $t1, 2
    add $t0, $t0, $t1
    lw $t2, ($t0)
    beqz $t2, proximo_vizinho
    
    la $t0, visitados
    sll $t1, $s3, 2
    add $t0, $t0, $t1
    lw $t2, ($t0)
    bnez $t2, proximo_vizinho
    
    move $a0, $s3
    move $a1, $s1
    addi $a2, $s2, 1
    jal dfs
    
proximo_vizinho:
    addi $s3, $s3, 1
    j loop_vizinhos
    
fim_loop_vizinhos:
    la $t0, visitados
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    sw $zero, ($t0)
    
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

imprimir_caminho:
    # Incrementar e imprimir número do caminho
    la $t0, contador_caminhos
    lw $t1, ($t0)
    addi $t1, $t1, 1
    sw $t1, ($t0)
    
    li $v0, 4
    la $a0, msg_caminhos
    syscall
    
    li $v0, 1
    move $a0, $t1
    syscall
    
    li $v0, 4
    la $a0, dois_pontos
    syscall
    
    li $t0, 0
    lw $t1, tam_caminho
    
loop_imprimir:
    beq $t0, $t1, distancia_e_tempo
    
    la $t2, caminho
    sll $t3, $t0, 2
    add $t2, $t2, $t3
    lw $t4, ($t2)
    addi $t4, $t4, 1  # Ajustar indice para 1 based
    
    jal print_lugar
    
    addi $t5, $t1, -1
    beq $t0, $t5, skip_separador
    li $v0, 4
    la $a0, separador2
    syscall
    
skip_separador:
    addi $t0, $t0, 1
    j loop_imprimir

distancia_e_tempo:
	# Inicializar contador
    li $t0, 0          # i = 0
    lw $t1, tam_caminho
	addi $t1, $t1, -1 # Nao e necessario percorrer o vetor todo
	la $t2, caminho # Vetor do trajeto
	
	li $t3, 0 # Acumulador para distancia
	li $t4, 0 # Acumulador para tempo 
	
	la $t5, distancias # Matriz de distancias
	
	jal tipo_transporte
	
loop_calculo:
	# Verificar se terminou
    beq $t0, $t1, fim_imprimir
	
	mul $t7, $t0, 4
	add $t2, $t2, $t7
	lw $s4, 0($t2)
	lw $s5, 4($t2)
	
	# Correcao dos indices
	#addi $s4, $s4, -1
	#addi $s5, $s5, -1
	
	mul $s6, $s4, 4
	add $s6, $s6, $s5
	mul $s6, $s6, 4
	add $s6, $t5, $s6
	
	lw $s7, 0($s6) # Carrega a distancia de um ponto para o outro
	add $t3, $s7, $t3 # Soma a distancia do trajeto
	
	mul $s6, $s4, 4
	add $s6, $s6, $s5
	mul $s6, $s6, 4
	add $s6, $t6, $s6
	
	lw $s7, 0($s6) # Carrega o tempo de um ponto para o outro
	add $t4, $s7, $t4 # Soma o tempo do trajeto
	
	addi $t0, $t0, 1
	
	j loop_calculo
	
tipo_transporte:
	beq $s4, 1, matriz_carro
	beq $s4, 2, matriz_onibus
	beq $s4, 3, matriz_bike
	j matriz_pe
	
matriz_carro:
	la $t6, tempos_carro
	
	jr $ra
	
matriz_onibus:
	la $t6, tempos_onibus
	
	jr $ra

matriz_bike:
	la $t6, tempos_bike
	
	jr $ra
	
matriz_pe:
	la $t6, tempos_pe
	
	jr $ra
	
print_lugar:
	beq $t4, 1, print_local1
	beq $t4, 2, print_local2
	beq $t4, 3, print_local3
	j print_local4

print_local1:
	li $v0, 4
	la $a0, local1
	syscall
	
	jr $ra
	
print_local2:
	li $v0, 4
	la $a0, local2
	syscall
	
	jr $ra
	
print_local3:
	li $v0, 4
	la $a0, local3
	syscall
	
	jr $ra
	
print_local4:
	li $v0, 4
	la $a0, local4
	syscall
	
	jr $ra

# Fazer backtracking em vez de voltar ao menu
fim_imprimir:
    li $v0, 4
    la $a0, saida_distancia
    syscall
    
    li $v0, 1
    move $a0, $t3
    syscall
    
    li $v0, 4
    la $a0, saida_tempo
    syscall
    
    li $v0, 1
    move $a0, $t4
    syscall
    
    li $v0, 4
    la $a0, enter
    syscall
    
    j fim_loop_vizinhos  # Continuar procurando outros caminhos

# Funcao para resetar array de visitados
reset_visitados:
    la $t0, visitados      # endereco base
    li $t1, 0              # i = 0
    
loop_reset:
    beq $t1, 4, fim_reset
    sll $t2, $t1, 2
    add $t3, $t0, $t2
    sw $zero, ($t3)
    addi $t1, $t1, 1
    j loop_reset
    
fim_reset:
    jr $ra

erro_input_local:
    # Mostrar mensagem de erro
    li $v0, 4
    la $a0, erro_local
    syscall
    j main
	
erro_input_transporte:
    # Mostrar mensagem de erro
    li $v0, 4
    la $a0, erro_transporte
    syscall
    j main
	
exit:
	li $v0, 4
	la $a0, tchau
	syscall

	li $v0, 10
	syscall