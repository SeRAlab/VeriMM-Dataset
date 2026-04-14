module top_module(
    input clk,
    input reset_n,
    input enable,
    output reg [4:0] q);always @(posedge clk) begin
    if (!reset_n)
        q <= 5'b11111;
    else if (enable)
        q <= q - 2;
end
endmodule