module top_module(
    input [7:0] A,
    input [7:0] B,
    input clk,
    output reg [7:0] Y
);always @(posedge clk) begin
    Y = A & B;
end

endmodule