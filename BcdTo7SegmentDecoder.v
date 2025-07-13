module BcdTo7SegmentDecoder (
    input [3:0] bcd_in,
    output reg [6:0] seg_out
);

    always @ (*) begin
        case(bcd_in)
            4'b0000   : seg_out = 7'b1000000;
				4'b0001   : seg_out = 7'b1111001;
				4'b0010   : seg_out = 7'b0100100;
				4'b0011   : seg_out = 7'b0110000;
				4'b0100   : seg_out = 7'b0011001;
				4'b0101   : seg_out = 7'b0010010;
				4'b0110   : seg_out = 7'b0000010;
				4'b0111   : seg_out = 7'b1111000;
				4'b1000   : seg_out = 7'b0000000;
				4'b1001   : seg_out = 7'b0011000;
            default: seg_out = 7'b1111111; // Desliga tudo
        endcase
    end

endmodule