module merge_sort_4 (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    output [3:0] out0,
    output [3:0] out1,
    output [3:0] out2,
    output [3:0] out3
);

wire [3:0] min1, min2, max1, max2;

// First stage: find min and max pairs
assign min1 = (a < b) ? a : b;
assign max1 = (a < b) ? b : a;
assign min2 = (c < d) ? c : d;
assign max2 = (c < d) ? d : c;

// Second stage: merge results
assign out0 = (min1 < min2) ? min1 : min2;
assign out3 = (min1 < min2) ? min2 : min1;
assign out1 = (max1 < min2) ? max1 : min2;
assign out2 = (max1 < min2) ? min2 : max1;

endmodule