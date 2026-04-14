module top_module(
    input clk,
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] C
);reg [3:0] sum;

always @(posedge clk) begin
    sum <= A + B;
    C <= sum;
end

endmodule