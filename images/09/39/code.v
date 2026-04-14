module merge_sort (
    input [15:0] data_in,
    output [15:0] data_out
);
    wire [3:0] a, b, c, d;
    assign {a, b, c, d} = data_in;

    wire [3:0] sorted1, sorted2;

    // First merge: sort a and b
    assign sorted1 = (a < b) ? a : b;
    assign sorted2 = (a < b) ? b : a;

    // Second merge: sort c and d
    wire [3:0] sorted3, sorted4;
    assign sorted3 = (c < d) ? c : d;
    assign sorted4 = (c < d) ? d : c;

    // Final merge: sort sorted1 and sorted3
    wire [3:0] final_sorted1, final_sorted2;
    assign final_sorted1 = (sorted1 < sorted3) ? sorted1 : sorted3;
    assign final_sorted2 = (sorted1 < sorted3) ? sorted3 : sorted1;

    // Prepare final output
    wire [3:0] final_sorted3, final_sorted4;
    assign final_sorted3 = (sorted2 < sorted4) ? sorted2 : sorted4;
    assign final_sorted4 = (sorted2 < sorted4) ? sorted4 : sorted2;

    // Final output composed of sorted values
    assign data_out = {final_sorted1, final_sorted2, final_sorted3, final_sorted4};
endmodule