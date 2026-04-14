module top_module(
    input [7:0] a, b, c, d,
    output [7:0] min);wire [7:0] ab_min, cd_min, abcd_min;

    assign ab_min = (a < b) ? a : b;
    assign cd_min = (c < d) ? c : d;
    assign abcd_min = (ab_min < cd_min) ? ab_min : cd_min;

    assign min = abcd_min;

endmodule