module adder(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

wire [8:0] temp_sum;
assign temp_sum = {1'b0, a} + {1'b0, b} + {1'b0, cin};

assign sum = temp_sum[7:0];
assign cout = temp_sum[8];

endmodule