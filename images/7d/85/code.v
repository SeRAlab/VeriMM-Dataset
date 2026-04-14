module top_module(
    a,
    b,
    cin,
    sum,
    cout
);input [3:0] a;
    input [3:0] b;
    input cin;
    output [3:0] sum;
    output cout;

    wire [3:0] temp_sum;
    wire [3:0] temp_carry;

    assign temp_sum[0] = a[0] ^ b[0] ^ cin;
    assign temp_carry[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    assign temp_sum[1] = a[1] ^ b[1] ^ temp_carry[0];
    assign temp_carry[1] = (a[1] & b[1]) | (a[1] & temp_carry[0]) | (b[1] & temp_carry[0]);

    assign temp_sum[2] = a[2] ^ b[2] ^ temp_carry[1];
    assign temp_carry[2] = (a[2] & b[2]) | (a[2] & temp_carry[1]) | (b[2] & temp_carry[1]);

    assign temp_sum[3] = a[3] ^ b[3] ^ temp_carry[2];
    assign cout = (a[3] & b[3]) | (a[3] & temp_carry[2]) | (b[3] & temp_carry[2]);

    assign sum = temp_sum;

endmodule