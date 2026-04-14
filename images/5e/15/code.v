module top_module(
    input clk,
    input rst,
    input [7:0] min,
    input [7:0] max,
    input [31:0] test_expr,
    input prevConfigInvalid,
    output reg out
);always @(posedge clk) begin
        if (rst) begin
            out <= 0;
        end else if (prevConfigInvalid) begin
            out <= 0;
        end else if (test_expr >= min && test_expr <= max) begin
            out <= 1;
        end else begin
            out <= 0;
        end
    end
    
endmodule