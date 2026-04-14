module register(
    input clk,
    input reset_n,
    input [3:0] data_in,
    output reg [3:0] data_out
    );
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            data_out <= 4'b0000;
        else
            data_out <= data_in;
    end
endmodule