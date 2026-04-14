module top_module(
    input [3:0] A,
    input clk,
    output reg [3:0] X
);reg [3:0] delayed_A;

always @(posedge clk) begin
    delayed_A <= A;
    X <= delayed_A;
end

always @(posedge clk) begin
    delayed_A <= X;
end

endmodule