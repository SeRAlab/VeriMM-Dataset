module merge_sort(input [3:0] a, input [3:0] b, input [3:0] c, input [3:0] d, output [15:0] sorted);
    wire [3:0] min1, min2, min3, min4;
    wire [3:0] max1, max2, max3, max4;

    // Find the minimum and maximum of a and b
    assign min1 = (a < b) ? a : b;
    assign max1 = (a < b) ? b : a;

    // Find the minimum and maximum of c and d
    assign min2 = (c < d) ? c : d;
    assign max2 = (c < d) ? d : c;

    // Find the minimum and maximum of min1 and min2
    assign min3 = (min1 < min2) ? min1 : min2;
    assign max3 = (min1 < min2) ? min2 : min1;

    // Now we have min3 as the smallest of all
    // Find the second smallest
    assign min4 = (max3 < min2) ? max3 : min2;
    assign max4 = (max3 < min2) ? min2 : max3;

    // Finally, we can find the remaining max values
    assign sorted = {max1, min4, min3, max2}; // Concatenate the sorted values

endmodule