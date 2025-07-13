module Extensor (in1, in2, in3, IMsel, out);

	input [13:0] in1;
	input [19:0] in2;
	input [25:0] in3;
	input [1:0] IMsel;
	
	output reg [31:0] out;
	
	
	always @ (*) begin
		
		if (IMsel == 2'b00) begin
			out = in1 + 32'd0;
		end
		if (IMsel == 2'b01) begin
			out = in2 + 32'd0;
		end
		if (IMsel == 2'b10) begin
			out = in3 + 32'd0;
		end
	end
	
endmodule
