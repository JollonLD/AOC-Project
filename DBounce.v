module DBounce (
    input clk,       
    input rst,      
    input noisy,     
    output reg clean 
);

    reg [25:0] count;
    reg new_state;

    always @(posedge clk) begin
        if (rst) begin
            count     <= 0;
            clean     <= 0;
            new_state <= 0;
        end else begin
            if (noisy != new_state) begin
                new_state <= noisy;
                count <= 0;
            end else begin
                if (count < 26'd50) begin
                    count <= count + 1;
                end else begin
                    clean <= new_state;
                end
            end
        end
    end

endmodule
