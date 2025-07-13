module Divisor_Freq(
	input clock_in,
	input reset,
	output reg clock_out
);

	reg [25:0] count;
	
	always @ (posedge clock_in) begin
		if (reset) begin
			count <= 26'd0;
			clock_out <= 1'b0;
		end
		else begin
			if (count == 26'd50) begin
				count <= 26'd0;
				clock_out = ~clock_out;
			end
			else begin
				count <= count + 26'd1;
			end
		end
	end
	
endmodule
