module top_module(
    input clk,
    input reset,
    input [15:0] a,
    input [15:0] b,
    output reg [31:0] result
);always @(posedge clk) begin
    if (reset) begin
        result <= 0;
    end else begin
        result <= a * b;
    end
end

endmodule