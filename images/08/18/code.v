module merge_sort_4input (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    output [3:0] out1,
    output [3:0] out2,
    output [3:0] out3,
    output [3:0] out4
);
    wire [3:0] min1, min2, max1, max2;

    // First pair comparison
    assign min1 = (a < b) ? a : b;
    assign max1 = (a < b) ? b : a;

    // Second pair comparison
    assign min2 = (c < d) ? c : d;
    assign max2 = (c < d) ? d : c;

    // Merge the two pairs
    assign out1 = (min1 < min2) ? min1 : min2;
    assign out2 = (min1 < min2) ? min2 : min1;
    assign out3 = (max1 < max2) ? max1 : max2;
    assign out4 = (max1 < max2) ? max2 : max1;

endmodule