module top_module(
    input clk,
    input reset,
    output reg [4:0] q);always @(posedge clk) begin
    if (reset)
        q <= 5'b00000;
    else
        q <= q + 1'b1;
end
endmodule