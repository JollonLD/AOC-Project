module MemoriaInstrucoes
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=5)
(
	input [(ADDR_WIDTH-1):0] addr_pc, 
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[12:0];
	
	initial begin
		$readmemb("codigo_teste.txt", rom);
	end

	always @ (*) begin
		q = rom[addr_pc];
	end
	
endmodule
