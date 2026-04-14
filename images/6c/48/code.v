module top_module (
    input clk,
    input enable,
    input [15:0] data_in,
    output reg [15:0] reg_out);always @(posedge clk) begin
        if (enable)
            reg_out <= data_in;
    end
    
endmodule