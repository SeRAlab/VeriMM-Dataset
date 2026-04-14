module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg [4:0] sum
);reg carry;

    always @(*) begin
        sum[0] = a[0] ^ b[0] ^ carry;
        sum[1] = a[1] ^ b[1] ^ carry;
        sum[2] = a[2] ^ b[2] ^ carry;
        sum[3] = a[3] ^ b[3] ^ carry;
        carry = (a[0] & b[0]) | (a[1] & b[1]) | (a[2] & b[2]) | (a[3] & b[3]) | (a[0] & b[1]) | (a[1] & b[2]) | (a[2] & b[3]) | (a[3] & 1'b0);
        sum[4] = carry;
    end

endmodule