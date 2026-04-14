module multiplier (
    input clk,
    input reset,
    input signed [13:0] a,
    input [15:0] b,
    output signed [31:0] result
);

reg signed [31:0] temp;

always @(*) begin
    temp = a * b;
    result = temp[31:0];
end

endmodule