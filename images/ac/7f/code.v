module top_module(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [8:0] sum
);wire [8:0] temp_sum;

assign temp_sum = {1'b0, a} + {1'b0, b} + {1'b0, c} + {1'b0, d};

assign sum = temp_sum[8] ? temp_sum + 1'b1 : temp_sum;

endmodule