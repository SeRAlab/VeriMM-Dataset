module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);wire [4:0] full_sum;
    assign full_sum = {1'b0, a} + {1'b0, b} + {1'b0, cin};

    assign sum = full_sum[3:0];
    assign cout = full_sum[4];

endmodule