module top_module (
    input clk,
    input rst,
    input load,
    input [7:0] data_in,
    output reg [7:0] reg_out);always @(posedge clk) begin
        if (rst)
            reg_out <= 8'b00000000;
        else if (load)
            reg_out <= data_in;
    end
    
endmodule