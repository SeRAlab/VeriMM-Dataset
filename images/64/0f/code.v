module top_module(
    input clk,
    input reset_n,
    output reg [2:0] q);always @(posedge clk) begin
    if (!reset_n)
        q <= 3'b000;
    else
        q <= {q[1:0], ~q[2]};
end
endmodule