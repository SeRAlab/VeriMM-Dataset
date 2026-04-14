module top_module(
    input clk,
    input reset,
    input up,
    input down,
    output reg [3:0] q);always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (up && ~down)
        q <= q + 1;
    else if (~up && down)
        q <= q - 1;
end
endmodule