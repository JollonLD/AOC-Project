module PC (
    input clock,
    input reset,
    input HLT,
    input stall,
    input confirm,
    input [31:0] in_pc,
    output [31:0] out_pc
);

    reg [31:0] pc;

    initial begin
        pc = 32'b0;
    end

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            pc <= 32'b0;
        end
        else if (HLT) begin
            pc <= pc;
        end
        else if (stall) begin 
            if (confirm) begin
					pc <= in_pc;
				end
				else begin
					pc <= pc;
				end
        end
		  else begin
				pc <= in_pc;
		  end
    end

    assign out_pc = pc;
	 
endmodule
