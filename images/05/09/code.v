module merge_sort (
    input [15:0] data_in,  // 4 unsigned 4-bit numbers
    output [15:0] data_out  // sorted output
);
    wire [3:0] a, b, c, d;
    assign {a, b, c, d} = data_in;

    // Sorting logic
    wire [3:0] min1, min2, min3, max1, max2;
    assign min1 = (a < b) ? a : b;
    assign max1 = (a < b) ? b : a;
    assign min2 = (c < d) ? c : d;
    assign max2 = (c < d) ? d : c;
    assign data_out[15:12] = (min1 < min2) ? min1 : min2;
    assign data_out[11:8]  = (min1 < min2) ? min2 : min1;
    assign data_out[7:4]   = (max1 < max2) ? max1 : max2;
    assign data_out[3:0]   = (max1 < max2) ? max2 : max1;
endmodule