module top_module(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input clk,
    input rst,
    output reg [7:0] out
);always @(posedge clk) begin
    if (rst) begin
        out <= 0;
    end else begin
        out <= a*b*c*d;
    end
end

endmodule