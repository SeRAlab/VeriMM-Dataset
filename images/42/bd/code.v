module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);wire [3:0] temp_sum;
    assign temp_sum = a + b + cin;
    
    assign sum = temp_sum;
    assign cout = (temp_sum[4] == 1) ? 1 : 0;
endmodule