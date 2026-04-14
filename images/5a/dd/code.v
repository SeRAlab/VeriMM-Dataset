module top_module(
    input clk,
    input reset,
    input up,
    output reg [2:0] q);always @(posedge clk) begin
    if (reset)
        q <= 3'b000;
    else if (up)
        q <= q + 1'b1;
    else
        q <= q - 1'b1;
end
endmodule