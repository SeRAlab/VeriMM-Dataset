module top_module(
    input [7:0] a,
    input [7:0] b,
    input clk,
    input rst,
    output reg [8:0] sum
);reg [8:0] carry;

always @ (posedge clk) begin
    if (rst) begin
        sum <= 0;
        carry <= 0;
    end else begin
        {carry, sum} <= a + b + carry;
    end
end

endmodule