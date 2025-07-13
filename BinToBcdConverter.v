module BinToBcdConverter (
    input [31:0] binary_in,
    output reg [3:0] bcd0,
    output reg [3:0] bcd1,
    output reg [3:0] bcd2,
    output reg [3:0] bcd3,
    output reg [3:0] bcd4,
    output reg [3:0] bcd5,
    output reg [3:0] bcd6,
    output reg [3:0] bcd7
);

    always @(*) begin
		  bcd0 = binary_in % 10;
		  bcd1 = (binary_in / 10) % 10;
		  bcd2 = (binary_in / 100) % 10;
		  bcd3 = (binary_in / 1000) % 10;
		  bcd4 = (binary_in / 10000) % 10;
		  bcd5 = (binary_in / 100000) % 10;
		  bcd6 = (binary_in / 1000000) % 10;
		  bcd7 = (binary_in / 10000000) % 10;
    end

endmodule
