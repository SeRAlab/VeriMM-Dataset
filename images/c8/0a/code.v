module adder(
    input [15:0] a,
    input [15:0] b,
    output [16:0] sum
);

reg [16:0] carry;
reg [16:0] temp_sum;

always @(*) begin
    temp_sum = a + b;
    carry = {temp_sum[16], temp_sum[15]};
    sum = temp_sum + (carry << 1);
end

endmodule