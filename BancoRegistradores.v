module BancoRegistradores(clock, addr_rs, addr_rt, addr_rd, escrita_dado, rp, RegWrite, PilhaE, JAL, dado1, dado2);
	
	input clock;
	
	input [5:0]addr_rs; // Endereço do registrador de entrada RS
	input [5:0]addr_rt; // Endereço do registrador de entrada RT
	input [5:0]addr_rd; // Endereço do registrador de entrada RD
	input [31:0]escrita_dado; // Valor do Dado que veio da ULA ou da Memória
	input [31:0]rp; // Novo endereço do $rp calculado da UC da Pilha
	
	// Sinais de Controle
	input RegWrite;
	input PilhaE;
	input JAL;
	
	output [31:0]dado1; // Saída do registrador RS
	output [31:0]dado2; // Saída do registrador RT
	
	// Posição para Registradores específicos:
	// $zero = 000000
	// $ra = 000001
	// $rp = 000010
	parameter addr_zero = 6'b000000;
	parameter addr_ra   = 6'b000001;
	parameter addr_rp   = 6'b000011;
	
	
	reg [31:0]banco[63:0]; // Banco de Registradores 64x32
	
	
	// inicializa o endereço salvo no $rp que será usado como topo da pilha na memória
	initial begin
		banco[addr_rp] = 32'd25;
	end
	
	always @ (negedge clock) begin
		
		banco[addr_zero] = 32'd0;
		
		if (RegWrite) begin
			banco[addr_rd] = escrita_dado;
		end

		if (PilhaE) begin
			banco[addr_rp] = rp;
		end
		
		if (JAL) begin
			banco[addr_ra] = escrita_dado;
		end
		
	end
	
	assign dado1 = banco[addr_rs];
	assign dado2 = PilhaE ? banco[addr_rp] : banco[addr_rt];

	
endmodule
