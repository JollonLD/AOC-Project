.data
grafo: .word 1, 1, 0, 1    # Vertice 0: conectado com 0, 1, e 3
       .word 1, 1, 1, 0    # Vertice 1: conectado com 0, 1, e 2
       .word 0, 1, 1, 0    # Vertice 2: conectado com 1 e 2
       .word 1, 0, 0, 1    # Vertice 3: conectado com 0 e 3

visitados: .word 0, 0, 0, 0  # Array para marcar vertices visitados
caminho: .word 0:10          # Array para armazenar o caminho atual (max 10 vertices)
tam_caminho: .word 0         # Tamanho atual do caminho

prompt_inicio: .asciiz "\nVertice inicial (0-3): "
prompt_fim: .asciiz "Vertice final (0-3): "
msg_caminho: .asciiz "\nCaminho encontrado: "
separador: .asciiz " -> "
quebra_linha: .asciiz "\n"
erro: .asciiz "\nErro: Digite um numero entre 0 e 3\n"

.text
.globl main

main:
    # Solicitar vertice inicial
    li $v0, 4
    la $a0, prompt_inicio
    syscall
    
    # Ler vertice inicial
    li $v0, 5
    syscall
    move $s0, $v0  # $s0 = vertice inicial
    
    # Verificar entrada
    bltz $s0, erro_input
    bgt $s0, 3, erro_input
    
    # Solicitar vertice final
    li $v0, 4
    la $a0, prompt_fim
    syscall
    
    # Ler vertice final
    li $v0, 5
    syscall
    move $s1, $v0  # $s1 = vertice final
    
    # Verificar entrada
    bltz $s1, erro_input
    bgt $s1, 3, erro_input
    
    # Inicializar busca
    jal reset_visitados
    
    # Iniciar DFS
    move $a0, $s0      # vertice atual = inicial
    move $a1, $s1      # vertice destino
    li $a2, 0          # profundidade atual = 0
    jal dfs

    # Encerrar programa
    li $v0, 10
    syscall

# Funcao DFS
dfs:
    # Salvar registradores na pilha
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    # Guardar parametros
    move $s0, $a0      # vertice atual
    move $s1, $a1      # vertice destino
    move $s2, $a2      # profundidade atual
    
    # Marcar vertice atual como visitado
    la $t0, visitados
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    li $t2, 1
    sw $t2, ($t0)
    
    # Adicionar vertice ao caminho
    la $t0, caminho
    sll $t1, $s2, 2
    add $t0, $t0, $t1
    sw $s0, ($t0)
    
    # Atualizar tamanho do caminho
    addi $t2, $s2, 1
    la $t0, tam_caminho
    sw $t2, ($t0)
    
    # Verificar se chegou ao destino
    beq $s0, $s1, imprimir_caminho
    
    # Explorar vizinhos
    li $s3, 0          # i = 0
    
loop_vizinhos:
    # Verificar se terminou os vertices
    beq $s3, 4, fim_loop_vizinhos
    
    # Verificar se existe aresta
    la $t0, grafo
    mul $t1, $s0, 4    # linha = vertice atual * 4
    add $t1, $t1, $s3  # + coluna
    sll $t1, $t1, 2    # * 4 (tamanho de word)
    add $t0, $t0, $t1
    lw $t2, ($t0)
    beqz $t2, proximo_vizinho
    
    # Verificar se vizinho ja foi visitado
    la $t0, visitados
    sll $t1, $s3, 2
    add $t0, $t0, $t1
    lw $t2, ($t0)
    bnez $t2, proximo_vizinho
    
    # Visitar vizinho recursivamente
    move $a0, $s3          # novo vertice atual
    move $a1, $s1          # mesmo destino
    addi $a2, $s2, 1      # profundidade + 1
    jal dfs
    
proximo_vizinho:
    addi $s3, $s3, 1      # i++
    j loop_vizinhos
    
fim_loop_vizinhos:
    # Desmarcar vertice como visitado (backtracking)
    la $t0, visitados
    sll $t1, $s0, 2
    add $t0, $t0, $t1
    sw $zero, ($t0)
    
    # Restaurar registradores e retornar
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# Funcao para imprimir o caminho atual
imprimir_caminho:
    # Imprimir mensagem inicial
    li $v0, 4
    la $a0, msg_caminho
    syscall
    
    # Inicializar contador
    li $t0, 0          # i = 0
    lw $t1, tam_caminho
    
loop_imprimir:
    # Verificar se terminou
    beq $t0, $t1, fim_imprimir
    
    # Imprimir vertice
    la $t2, caminho
    sll $t3, $t0, 2
    add $t2, $t2, $t3
    lw $a0, ($t2)
    li $v0, 1
    syscall
    
    # Imprimir separador se nao for o ultimo
    addi $t4, $t1, -1
    beq $t0, $t4, skip_separador
    li $v0, 4
    la $a0, separador
    syscall
    
skip_separador:
    addi $t0, $t0, 1      # i++
    j loop_imprimir
    
fim_imprimir:
    # Imprimir quebra de linha
    li $v0, 4
    la $a0, quebra_linha
    syscall
    
    # Continuar a busca
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

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

erro_input:
    # Mostrar mensagem de erro
    li $v0, 4
    la $a0, erro
    syscall
    j main