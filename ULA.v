module ULA(in1, in2, ALUop, sz, branch, result);

	input [31:0]in1; // Dado de Entrada 1
	input [31:0]in2; // Dado de Entrada 2
	input [3:0]ALUop; // Sinal da Operação da ULA
	input sz; // Sinal para controlar casos de Endereço
	output branch;
	output [31:0]result;
	
	reg [31:0]r;
	reg b;

	// ALUop codes
	// add:  0000
	// sub:  0001
	// mult: 0010
	// div:  0011
	// and:  0100
	// or:   0101
	// not:  0110
	// beq:  0111
	// bge:  1000
	// ble:  1001
	// blt:  1010
	// bgt:  1011
	// sl:  1100
	// sr:  1101
	
	always @ (*) 
		begin
			// valores padrão
			r = 32'b0;
			b = 1'b0;

    if (sz == 1'b1) 
		 begin
			  r = in2;
		 end 
	 else 
		begin
        case (ALUop)
            4'b0000: r = in1 + in2;
            4'b0001: r = in1 - in2;
            4'b0010: r = in1 * in2;
            4'b0011: r = in1 / in2;
            4'b0100: r = in1 & in2;
            4'b0101: r = in1 | in2;
            4'b0110: r = ~in1;
            4'b0111: b = (in1 == in2);
            4'b1000: b = (in1 >= in2);
            4'b1001: b = (in1 <= in2);
            4'b1010: b = (in1 < in2);
            4'b1011: b = (in1 > in2);
            4'b1100: r = in1 << 1;  // shift left
            4'b1101: r = in1 >> 1;  // shift right
            default: 
					begin 
						r = 32'b0; 
						b = 1'b0;
					end
			endcase
		end
	end
		
		assign result = r;
		assign branch = b;
		
endmodule
