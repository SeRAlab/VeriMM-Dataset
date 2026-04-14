module top_module(
    input signed [15:0] a,
    input signed [15:0] b,
    input cin,
    output signed [15:0] sum,
    output cout
);wire [15:0] unsigned_sum;
    wire unsigned_cout;

    assign unsigned_sum = a + b + cin;
    assign cout = (a[15] & b[15]) | ((a[15] | b[15]) & ~unsigned_sum[15]);
    assign sum = (a[15] == b[15]) ? unsigned_sum : (a > b) ? a + b : b + a;

endmodule