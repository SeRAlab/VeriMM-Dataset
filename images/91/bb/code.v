module top_module(
    input clk,
    input enable,
    input [3:0] d,
    output reg [3:0] q);always @(posedge clk) begin
    if (enable)
        q <= {1'b0, q[3:1]};
end
endmodule