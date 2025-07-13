module ModuloEntradaSaida (
    input [9:0] switch_dado,
    input [31:0] entrada_dado,
    input IOE,
    input IOsel,
	 input confirm,
    output reg [31:0] saida_dado,

    output [6:0] HEX0, 
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5,
    output [6:0] HEX6,
    output [6:0] HEX7  
);

    // Sinais BCD individuais
    wire [3:0] bcd0, bcd1, bcd2, bcd3;
    wire [3:0] bcd4, bcd5, bcd6, bcd7;

    // Valor que vai ser exibido
    reg [31:0] reg_out;

    // Logica de seleção: mostra switches ou entrada
    always @(*) begin
        if (IOE) begin
				if (IOsel) begin
					saida_dado = switch_dado + 32'b0; // concatena zeros nos bits mais altos
				end
				else if (confirm) begin
					reg_out = entrada_dado;
				end
		  end
        else begin
            reg_out = reg_out;
		  end
	 end

    // Conversor Binário -> BCD
    BinToBcdConverter b2b_inst (
        .binary_in(reg_out),
        .bcd0(bcd0),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3),
        .bcd4(bcd4),
        .bcd5(bcd5),
        .bcd6(bcd6),
        .bcd7(bcd7)
    );

    // Decodificadores
    BcdTo7SegmentDecoder dec0_inst (.bcd_in(bcd0), .seg_out(HEX0));
    BcdTo7SegmentDecoder dec1_inst (.bcd_in(bcd1), .seg_out(HEX1));
    BcdTo7SegmentDecoder dec2_inst (.bcd_in(bcd2), .seg_out(HEX2));
    BcdTo7SegmentDecoder dec3_inst (.bcd_in(bcd3), .seg_out(HEX3));
    BcdTo7SegmentDecoder dec4_inst (.bcd_in(bcd4), .seg_out(HEX4));
    BcdTo7SegmentDecoder dec5_inst (.bcd_in(bcd5), .seg_out(HEX5));
    BcdTo7SegmentDecoder dec6_inst (.bcd_in(bcd6), .seg_out(HEX6));
    BcdTo7SegmentDecoder dec7_inst (.bcd_in(bcd7), .seg_out(HEX7));

endmodule
