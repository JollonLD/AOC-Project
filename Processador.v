module Processador (clk, switches, confirm, reset, saida_pc, endereco_RS, endereco_RT, endereco_RD, dado1_entrada_ULA, dado2_entrada_ULA, saida_ULA, ula_Zero, intrucao_lida, 
	endereco_acesso_memoria, dado_leitura_memoria, dado_escrita_banco, saida_dbg_io, JAL, JR, HLT, DadoSel, PilhaE, PilhaOP, SZ, ResSel, ALUOp, MemToReg, 
	RegWrite, ALUsrc, MemRead, MemWrite, Branch, RSsel, RTsel, IMsel, Jump, IOE, IOsel, stall, clock_div, l0, l1, l2, l3, l4, l5, l6, l7);
	 
	input clk;
	input reset;
	input [9:0] switches;
	input confirm;
	
	
	wire SZ;
	wire JAL;
	wire JR;
	wire HLT;
	wire Jump;
	wire Branch;
	wire RegWrite;
	wire RSsel;
	wire RTsel;
	wire DadoSel;
	wire ResSel;
	wire PilhaE;
	wire PilhaOP;
	wire ALUsrc;
	wire MemToReg;
	wire MemRead;
	wire MemWrite;
	wire IOE;
	wire IOsel;
	wire stall;
	wire [1:0] IMsel;
	wire [3:0] ALUOp;

	
	output        SZ;
	output        JAL;
	output        JR;
	output        HLT;
	output        Jump;
	output        Branch;
	output        RegWrite;
	output        RSsel;
	output        RTsel;
	output        DadoSel;
	output        ResSel;
	output        PilhaE;
	output        PilhaOP;
	output        ALUsrc;
	output        MemToReg;
	output        MemRead;
	output        MemWrite;
	output		  IOE;
	output		  IOsel;
	output		  stall;
	output [1:0]  IMsel;
	output [3:0]  ALUOp;
	
	
	wire [31:0] instrucao;
	wire [31:0] dado1; 
	wire [31:0] dado2;
	wire [31:0] addr_rs;
	wire [31:0] addr_rt;
	wire [31:0] addr_rd; 
	wire [31:0] Imediato; 
	wire [31:0] in1; 
	wire [31:0] in2; 
	wire [31:0] resultado; 
	wire [31:0] escrita_dado; 
	wire [31:0] rp; 
	wire [31:0] in_pc; 
	wire [31:0] out_pc; 
	wire [31:0] rp_mem; 
	wire [31:0] mem_out; 
	wire [31:0] addr_leitura;
	wire [31:0] result_out;
	wire [31:0] mem_reg_out;
	wire [31:0] pc_plus_one; 
	wire [31:0] pc_branch;
	wire [31:0] pc_jump; 
	wire [31:0] pc_jr_jump;
	wire [31:0] mem_io_out;
	wire [31:0] saida_io;
	wire Zero;
	wire and_branch;
	output [6:0] l0, l1, l2, l3, l4, l5, l6, l7;
	
	
	output ula_Zero;
	output [4:0]  saida_pc;
	output [5:0]  endereco_RS;
	output [5:0]  endereco_RT;
	output [5:0]  endereco_RD;
	output [31:0] dado1_entrada_ULA;
	output [31:0] dado2_entrada_ULA;
	output [31:0] saida_ULA;  
	output [31:0] intrucao_lida;
	output [7:0]  endereco_acesso_memoria;
	output [31:0] dado_leitura_memoria;
	output [31:0] dado_escrita_banco;
	output [31:0] saida_dbg_io;
	output clock_div;
	
	wire clock;
	
	Divisor_Freq div (
		.clock_in(clk),
		.reset(reset),
		.clock_out(clock)
	);
	
	assign clock_div = clock;
	
	Adder somador_1 (
		.a(32'd1),
		.b(out_pc),
		.out(pc_plus_one) 
	);
	
	Adder somador_2 (
		.a(pc_plus_one),
		.b(Imediato),
		.out(pc_branch)  
	);

	mux mux_jr (
		.a(Imediato),
		.b(dado1),
		.s(JR),
		.out(pc_jr_jump)
	);

	mux mux_jump (
		.a(pc_plus_one),
		.b(pc_jr_jump),
		.s(Jump),
		.out(pc_jump)
	);

	assign and_branch = Zero & Branch;

	mux mux_branch (
		.a(pc_jump),
		.b(pc_branch),
		.s(and_branch),
		.out(in_pc)
	);

	PC pc (
		.clock(clock),
		.reset(reset),
		.HLT(HLT),
		.stall(stall),
		.confirm(confirm),
		.in_pc(in_pc), 
		.out_pc(out_pc)  
	);	

	MemoriaInstrucoes mem_instr (
		.addr_pc(out_pc[5:0]),
		.q(instrucao) 
	);
	
	UnidadeControle UC (
		.opcode(instrucao[31:26]), 
		.JAL(JAL), 
		.JR(JR), 
		.HLT(HLT), 
		.DadoSel(DadoSel), 
		.PilhaE(PilhaE), 
		.PilhaOP(PilhaOP), 
		.SZ(SZ), 
		.ResSel(ResSel), 
		.ALUOp(ALUOp), 
		.MemToReg(MemToReg), 
		.RegWrite(RegWrite), 
		.ALUsrc(ALUsrc), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.Branch(Branch), 
		.RSsel(RSsel), 
		.RTsel(RTsel), 
		.IMsel(IMsel), 
		.Jump(Jump),
		.IOE(IOE),
		.IOsel(IOsel),
		.stall(stall)
	);
	
	mux mux_rs (
		.a(instrucao[19:14]),
		.b(instrucao[25:20]),
		.s(RSsel),
		.out(addr_rs)
	);

	mux mux_rt (
		.a(instrucao[13:8]),
		.b(instrucao[19:14]),
		.s(RTsel),
		.out(addr_rt)
	);

	assign addr_rd = instrucao[25:20];

	mux mux_reg_ra (
		.a(mem_io_out),
		.b(pc_plus_one),  // $ra
		.s(JAL),
		.out(escrita_dado)
	);

	BancoRegistradores banco (
		.clock(clock),
		.addr_rs(addr_rs),
		.addr_rt(addr_rt),
		.addr_rd(addr_rd),
		.escrita_dado(escrita_dado),
		.rp(rp),
		.RegWrite(RegWrite),
		.PilhaE(PilhaE),
		.JAL(JAL),
		.dado1(dado1),
		.dado2(dado2)
	);

	Extensor extensor (
		.in1(instrucao[13:0]),
		.in2(instrucao[19:0]),
		.in3(instrucao[25:0]),
		.IMsel(IMsel),
		.out(Imediato)  
	);

	mux mux_sel_in1_ULA (
		.a(dado1),
		.b(dado2),
		.s(DadoSel),
		.out(in1)
	);

	mux mux_sel_in2_ULA (
		.a(dado2),
		.b(Imediato),
		.s(ALUsrc),
		.out(in2)
	);

	ULA ula (
		.in1(in1),
		.in2(in2),
		.ALUop(ALUOp),
		.sz(SZ),
		.result(resultado),
		.branch(Zero)
	);

	UC_Pilha pilha_ctrl (
		.rp_in(dado2),
		.PilhaE(PilhaE),
		.PilhaOP(PilhaOP),
		.rp_out(rp), 
		.rp_mem(rp_mem)  
	);

	mux mux_addr_leitura (
		.a(resultado),
		.b(rp_mem),
		.s(PilhaE),
		.out(addr_leitura)
	);

	MemoriaDados mem_dados (
		.clk(clock),
		.data(dado2),	
		.addr(addr_leitura[7:0]),
		.MemWrite(MemWrite),
		.MemRead(MemRead),
		.q(mem_out)  
	);

	mux mux_result (
		.a(resultado),
		.b(Imediato),
		.s(ResSel),
		.out(result_out)  
	);

	mux mux_MemReg (
		.a(result_out),
		.b(mem_out),
		.s(MemToReg),
		.out(mem_reg_out) 
	);

	mux mux_io (
		.a(mem_reg_out),
		.b(saida_io),
		.s(IOsel),
		.out(mem_io_out)
	);
	
	
	ModuloEntradaSaida in_out (
		.switch_dado(switches),
		.entrada_dado(in1),
		.IOE(IOE),
		.IOsel(IOsel),
		.confirm(confirm),
		.saida_dado(saida_io),
		.HEX0(l0),
		.HEX1(l1),
		.HEX2(l2),
		.HEX3(l3),
		.HEX4(l4),
		.HEX5(l5), 
		.HEX6(l6),
		.HEX7(l7)
	);
	
	assign saida_dbg_io				  = saida_io;
	assign saida_pc                 = out_pc[4:0];
	assign endereco_RS              = addr_rs;
	assign endereco_RT              = addr_rt;
	assign endereco_RD              = addr_rd;
	assign dado1_entrada_ULA        = in1;
	assign dado2_entrada_ULA        = in2;
	assign saida_ULA                = resultado;
	assign intrucao_lida            = instrucao;
	assign endereco_acesso_memoria  = addr_leitura[7:0];
	assign dado_leitura_memoria     = mem_out;
	assign dado_escrita_banco       = escrita_dado;
	assign ula_Zero					  = Zero;
 
endmodule
