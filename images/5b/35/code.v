module top_module(
    input clk,
    input set,
    input enable,
    input [11:0] d,
    output reg [11:0] q);always @(posedge clk or posedge set) begin
    if (set)
        q <= 12'b111111111111;
    else if (enable)
        q <= d;
end
endmodule