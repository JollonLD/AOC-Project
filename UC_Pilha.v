module UC_Pilha (rp_in, PilhaE, PilhaOP, rp_out, rp_mem);
	
	input [31:0] rp_in;
	input PilhaE;
	input PilhaOP;
	
	output reg [31:0] rp_out; // Volta para banco 
	output reg [31:0] rp_mem; // Acessa a memoria
	
	always @ (*) begin
		
		if (PilhaE) begin
			if (PilhaOP) begin
				// Push
				rp_out = rp_in + 32'd1;
				rp_mem = rp_in + 32'd1;
			end
			else begin
				// Pop
				rp_out = rp_in - 32'd1;
				rp_mem = rp_in;
			end
		end
	end
	
endmodule
