.data
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

prompt_inicio: .asciiz "\nInsira o numero do local de inicio (1-4): "
prompt_destino: .asciiz "Insira o numero do local de destino (1-4): "
prompt_transporte: .asciiz "Escolha o meio de transporte (1-4): "
resultado: .asciiz "\nDistancia em km: "
separador: .asciiz "\nTempo estimado em minutos: "
erro_local: .asciiz "\nErro: Por favor insira numeros entre 1 e 4 para os locais.\n"
erro_transporte: .asciiz "\nErro: Por favor insira numeros entre 1 e 4 para o transporte.\n"

.text
.globl main

main:
    # Mostrar os locais disponiveis
    la $a0, locais
    li $v0, 4
    syscall

input_inicio:
    # Solicitar local de inicio
    li $v0, 4
    la $a0, prompt_inicio
    syscall

    # Ler local de inicio
    li $v0, 5
    syscall
    move $t0, $v0  # Salvar local de inicio em $t0
    
    # Verificar se o numero esta entre 1 e 4
    blt $t0, 1, erro_input_local
    bgt $t0, 4, erro_input_local

input_destino:
    # Solicitar local de destino
    li $v0, 4
    la $a0, prompt_destino
    syscall

    # Ler local de destino
    li $v0, 5
    syscall
    move $t1, $v0  # Salvar local de destino em $t1
    
    # Verificar se o numero esta entre 1 e 4
    blt $t1, 1, erro_input_local
    bgt $t1, 4, erro_input_local

input_transporte:
    # Mostrar opcoes de transporte
    la $a0, transportes
    li $v0, 4
    syscall

    # Solicitar meio de transporte
    la $a0, prompt_transporte
    li $v0, 4
    syscall

    # Ler meio de transporte
    li $v0, 5
    syscall
    move $t2, $v0  # Salvar meio de transporte em $t2

    # Verificar se o numero esta entre 1 e 4
    blt $t2, 1, erro_input_transporte
    bgt $t2, 4, erro_input_transporte

calcular:
    # Converter para indices base-0
    addi $t0, $t0, -1  # Indice do local de inicio
    addi $t1, $t1, -1  # Indice do local de destino
    addi $t2, $t2, -1  # Indice do transporte

    # Calcular indice na matriz para distancias
    mul $t3, $t0, 4    # Multiplicar linha por 4 (numero de colunas)
    add $t3, $t3, $t1  # Adicionar coluna
    mul $t3, $t3, 4    # Multiplicar por 4 (tamanho de cada word)
    
    # Carregar distancia
    la $t4, distancias
    add $t4, $t4, $t3
    lw $s0, ($t4)      # Salvar a distancia em $s0

    # Selecionar matriz de tempo baseado no transporte
    beq $t2, 0, usar_carro
    beq $t2, 1, usar_onibus
    beq $t2, 2, usar_bike
    j usar_pe

continuar_calculo:
    add $t4, $t4, $t3  # Adicionar offset calculado
    lw $s1, ($t4)      # Salvar o tempo em $s1

    # Mostrar resultados
    li $v0, 4
    la $a0, resultado
    syscall

    # Mostrar distancia
    li $v0, 1
    move $a0, $s0
    syscall

    # Mostrar tempo
    li $v0, 4
    la $a0, separador
    syscall

    li $v0, 1
    move $a0, $s1
    syscall

    # Encerrar programa
    j exit

usar_carro:
    la $t4, tempos_carro
    j continuar_calculo

usar_onibus:
    la $t4, tempos_onibus
    j continuar_calculo

usar_bike:
    la $t4, tempos_bike
    j continuar_calculo

usar_pe:
    la $t4, tempos_pe
    j continuar_calculo

erro_input_local:
    # Mostrar mensagem de erro para locais
    li $v0, 4
    la $a0, erro_local
    syscall
    j input_inicio

erro_input_transporte:
    # Mostrar mensagem de erro para transporte
    li $v0, 4
    la $a0, erro_transporte
    syscall
    j input_transporte

exit:
    li $v0, 10
    syscall