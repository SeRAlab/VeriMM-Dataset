module top_module(
    input [7:0] a, b, c, d,
    output [7:0] min);wire [7:0] ab_min, cd_min, abcd_min;

    // Comparators to find minimum of a and b
    assign ab_min = (a < b) ? a : b;

    // Comparators to find minimum of c and d
    assign cd_min = (c < d) ? c : d;

    // Comparators to find minimum of ab_min and cd_min
    assign abcd_min = (ab_min < cd_min) ? ab_min : cd_min;

    assign min = abcd_min;

endmodule