module add_two_signals (
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] sum,
    output reg carry_out
);

always @(*) begin
    sum = A + B;
    carry_out = (sum[4] == 1);
end

endmodule