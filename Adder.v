module Adder (a, b, out);
	
	input [31:0] a;
	input [31:0] b;
	
	output reg [31:0] out;
	
	always @ (*) begin
			
		out = a + b;
	
	end
	
endmodule
