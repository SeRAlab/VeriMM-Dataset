module ripple_carry_adder(
    input clk,
    input reset,
    input [13:0] a,
    input [13:0] b,
    output reg [13:0] sum);

always @(posedge reset, posedge clk) begin
    if (reset)
        sum <= 14'b00000000000000;
    else
        sum <= a + b;
end
endmodule