module top_module(
    input clk,
    input reset,
    input enable,
    output reg [15:0] q);always @(posedge clk) begin
    if (reset)
        q <= 16'b1111_1111_1111_1111;
    else if (enable)
        q <= q - 1;
end
endmodule