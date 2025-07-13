module UnidadeControle (opcode, JAL, JR, HLT, DadoSel, PilhaE, PilhaOP, SZ, 
						ResSel, ALUOp, MemToReg, RegWrite, ALUsrc, MemRead, 
						MemWrite, Branch, RSsel, RTsel, IMsel, Jump, IOE, IOsel, stall);

	input [5:0] opcode;
	
	output reg SZ;
	output reg JAL;
	output reg JR;
	output reg HLT;
	output reg Jump;
	output reg Branch;
	output reg RegWrite;
	output reg RSsel;
	output reg RTsel;
	output reg DadoSel;
	output reg ResSel;
	output reg PilhaE;
	output reg PilhaOP;
	output reg ALUsrc;
	output reg MemToReg;
	output reg MemRead;
	output reg MemWrite;
	output reg IOE;
	output reg IOsel;
	output reg stall;
	output reg [1:0] IMsel;
	output reg [3:0] ALUOp;
	
	always @ (*) begin
		JAL 		= 0; 
		JR 		= 0;
		HLT 		= 0;
		DadoSel 	= 0; 
		PilhaE 	= 0;
		PilhaOP 	= 0;
		SZ 		= 0;
		ResSel 	= 0;  
		MemToReg = 0;
		RegWrite = 0;
		ALUsrc 	= 0;
		MemRead 	= 0;
		MemWrite = 0;
		Branch 	= 0;
		RSsel 	= 0;
		RTsel 	= 0;
		Jump 		= 0;
		IMsel 	= 2'b00;
		ALUOp 	= 4'b0000;
		IOE		= 0;
		IOsel		= 0;
		stall 	= 0;
		
		case (opcode)
			// add
			6'b000000: begin
				ALUOp = 4'b0000;
				RegWrite = 1;
			end
			// sub
			6'b000001:begin
				ALUOp = 4'b0001;
				RegWrite = 1;
			end
			// mult
			6'b000010:begin
				ALUOp = 4'b0010;
				RegWrite = 1;
			end
			// div
			6'b000011:begin
				ALUOp = 4'b0011;
				RegWrite = 1;
			end
			// AND
			6'b000100:begin
				ALUOp = 4'b0100;
				RegWrite = 1;
			end
			// OR
			6'b000101:begin
				ALUOp = 4'b0101;
				RegWrite = 1;
			end
			// NOT
			6'b000110:begin
				ALUOp = 4'b0110;
				RegWrite = 1;
			end
			// addi
			6'b000111:begin
				ALUOp = 4'b0000;
				RegWrite = 1;
				IMsel = 2'b00;
				ALUsrc = 1;
			end
			// subi
			6'b001000:begin
				ALUOp = 4'b0001;
				RegWrite = 1;
				IMsel = 2'b00;
				ALUsrc = 1;
			end
			// multi
			6'b001001:begin
				ALUOp = 4'b0010;
				RegWrite = 1;
				IMsel = 2'b00;
				ALUsrc = 1;
			end
			// ANDI
			6'b001010:begin
				ALUOp = 4'b0100;
				RegWrite = 1;
				IMsel = 2'b00;
				ALUsrc = 1;
			end
			// ORI
			6'b001011:begin
				ALUOp = 4'b0101;
				RegWrite = 1;
				IMsel = 2'b00;
				ALUsrc = 1;
			end
			// sr
			6'b001100:begin
				ALUOp = 4'b1101;
				RegWrite = 1;
			end
			// sl
			6'b001101:begin	
				ALUOp = 4'b1100;
				RegWrite = 1;
			end
			// bge
			6'b001110:begin
				ALUOp = 4'b1000;
				Branch = 1;
				IMsel = 2'b01;
				RSsel = 1;
				RTsel = 1;
			end
			// beq
			6'b001111:begin
				ALUOp = 4'b0111;
				Branch = 1;
				IMsel = 2'b01;
				RSsel = 1;
				RTsel = 1;
			end
			// bgt
			6'b010000:begin
				ALUOp = 4'b1011;
				Branch = 1;
				IMsel = 2'b01;
				RSsel = 1;
				RTsel = 1;
			end
			// blt
			6'b010001:begin
				ALUOp = 4'b1010;
				Branch = 1;
				IMsel = 2'b01;
				RSsel = 1;
				RTsel = 1;
			end
			// ble
			6'b010010:begin
				ALUOp = 4'b1001;
				Branch = 1;
				IMsel = 2'b01;
				RSsel = 1;
				RTsel = 1;
			end
			// move 
			6'b010011:begin
				SZ = 1;
				RegWrite = 1;
				RTsel = 1;
			end			
			// li
			6'b010100:begin
				SZ = 1;
				RegWrite = 1;
				IMsel = 2'b01;
				ALUsrc = 1;
			end			
			// lw
			6'b010101:begin
				SZ = 1;
				RegWrite = 1;
				IMsel = 2'b01;
				ALUsrc = 1;
				MemRead = 1;
				MemToReg = 1;
			end		
			// sw
			6'b010110:begin
				SZ = 1;
				RSsel = 1;
				IMsel = 2'b01;
				ALUsrc = 1;
				MemWrite = 1;
			end		
			// lwr
			6'b010111:begin
				ALUOp = 4'b0000;
				RegWrite = 1;
				MemRead = 1;
				MemToReg = 1;
			end	
			// swr
			6'b011000:begin
				ALUOp = 4'b0000;
				RSsel = 1;
				RTsel = 1;
				MemWrite = 1;
			end		
			// lwd
			6'b011001:begin
				ALUOp = 4'b0000;
				ALUsrc = 1;
				IMsel = 2'b00;
				MemRead = 1;
				RegWrite = 1;
				MemToReg = 1;
			end		
			// swd
			6'b011010:begin
				ALUOp = 4'b0000;
				ALUsrc = 1;
				IMsel = 2'b00;
				RSsel = 1;
				RTsel = 1;
				MemWrite = 1;
			end	
			// j 
			6'b011011:begin
				Jump = 1;
				IMsel = 2'b10;
			end	
			// jr
			6'b011100:begin
				RSsel = 1;
				Jump = 1;
				JR = 1;
			end
			// jal
			6'b011101:begin
				JAL = 1;
				IMsel = 2'b10;
				Jump = 1;
			end
			// PUSH
			6'b011110:begin
				RSsel = 1;
				PilhaE = 1;
				PilhaOP = 1;
				MemWrite = 1;
			end
			// POP
			6'b011111:begin
				PilhaE = 1;
				PilhaOP = 1;
				MemRead = 1;
				MemToReg = 1;
			end
			
			// IN
			6'b100000:begin
				IOE = 1;
				IOsel = 1;
				stall = 1;
				RegWrite = 1;
			end
			
			// OUT
			6'b100001:begin
				IOE = 1;
				IOsel = 0;
				RSsel = 1;
			end
			
			// HLT
			6'b100011:begin
			 	HLT = 1;
			end
			
			default: begin
				JAL 		= 0; 
				JR 		= 0;
				HLT 		= 0;
				DadoSel 	= 0; 
				PilhaE 	= 0;
				PilhaOP 	= 0;
				SZ 		= 0;
				ResSel 	= 0;  
				MemToReg = 0;
				RegWrite = 0;
				ALUsrc 	= 0;
				MemRead 	= 0;
				MemWrite = 0;
				Branch 	= 0;
				RSsel 	= 0;
				RTsel 	= 0;
				Jump 		= 0;
				IMsel 	= 2'b00;
				ALUOp 	= 4'b0000;
				IOE		= 0;
				IOsel		= 0;
				stall 	= 0;
			end
		
		endcase
	
	end
	
	
endmodule
