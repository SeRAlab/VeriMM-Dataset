module top_module
(
    input clk,
    input sreset,
    input enable,
    output reg [3:0] count
);function [3:0] gray_code (input [3:0] bin);
    gray_code = bin ^ (bin >> 1);
endfunction

always @(posedge clk)
        if (sreset) begin
            count <= 4'b0000;
        end else if (enable) begin
            count <= gray_code(count + 1);
        end
endmodule