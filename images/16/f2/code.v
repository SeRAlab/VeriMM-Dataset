module matrix_filter(
    input [7:0] pixel00, pixel01, pixel02,
    input [7:0] pixel10, pixel11, pixel12,
    input [7:0] pixel20, pixel21, pixel22,
    output [11:0] output_sum
);

assign output_sum = pixel00 + pixel01 + pixel02 +
                    pixel10 + pixel11 + pixel12 +
                    pixel20 + pixel21 + pixel22;

endmodule