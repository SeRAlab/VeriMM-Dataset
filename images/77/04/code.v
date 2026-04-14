module top_module(
    input clk,
    input reset,
    input j,
    input k,
    output reg q);always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0;
        end else if (j && ~k) begin
            q <= 1'b1;
        end else if (~j && k) begin
            q <= 1'b0;
        end else if (j && k) begin
            q <= ~q;
        end
    end

endmodule