module quick_sort(
    input [3:0] arr_in,
    output [3:0] arr_out
);
    wire [3:0] sorted;

    assign sorted[0] = (arr_in[0] < arr_in[1]) ? arr_in[0] : arr_in[1];
    assign sorted[1] = (arr_in[0] < arr_in[1]) ? arr_in[1] : arr_in[0];
    assign sorted[2] = (arr_in[2] < arr_in[3]) ? arr_in[2] : arr_in[3];
    assign sorted[3] = (arr_in[2] < arr_in[3]) ? arr_in[3] : arr_in[2];

    assign arr_out[0] = (sorted[0] < sorted[2]) ? sorted[0] : sorted[2];
    assign arr_out[1] = (sorted[0] < sorted[2]) ? sorted[2] : sorted[0];
    assign arr_out[2] = (sorted[1] < sorted[3]) ? sorted[1] : sorted[3];
    assign arr_out[3] = (sorted[1] < sorted[3]) ? sorted[3] : sorted[1];

endmodule