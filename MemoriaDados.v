module MemoriaDados
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] addr,
	input MemWrite, MemRead, clk,
	output [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	always @ (negedge clk) begin
		// Write
		if (MemWrite)
			ram[addr] <= data;
	end
	
	assign q = MemRead ? ram[addr] : 32'b0;
	
endmodule
