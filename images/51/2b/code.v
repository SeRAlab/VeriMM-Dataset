module top_module(
    input signed [3:0] a,
    input signed [3:0] b,
    input signed cin,
    output signed [3:0] sum,
    output signed cout
);wire signed [3:0] temp_sum;
wire signed temp_cout;

assign temp_sum = a + b + cin;
assign sum = temp_sum[3:0];
assign temp_cout = (temp_sum[4] == 1) ? 1 : 0;
assign cout = temp_cout;

endmodule