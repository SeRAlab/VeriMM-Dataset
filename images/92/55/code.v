module top_module(
    input [7:0] a, b, c, d,
    output [7:0] min);wire a_is_min, b_is_min, c_is_min, d_is_min;
    assign a_is_min = ((a < b) & (a < c) & (a < d)) ? 1: 0;
    assign b_is_min = ((b < a) & (b < c) & (b < d)) ? 1: 0;
    assign c_is_min = ((c < a) & (c < b) & (c < d)) ? 1: 0;
    assign d_is_min = ((d < a) & (d < b) & (d < c)) ? 1: 0;
    assign min = ((a_is_min) ? a :
                  (b_is_min) ? b :
                  (c_is_min) ? c :
                  d );

endmodule