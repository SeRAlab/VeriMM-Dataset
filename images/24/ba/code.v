module merge_sort (
    input [15:0] data_in, // 4 elements, 4 bits each
    output [15:0] data_out // sorted 4 elements
);
    wire [3:0] a, b, c, d;
    assign {a, b, c, d} = data_in;

    wire [3:0] temp1, temp2;
    wire [3:0] sorted1, sorted2;

    assign temp1 = (a < b) ? a : b;
    assign temp2 = (a < b) ? b : a;
    
    assign sorted1 = (c < d) ? c : d;
    assign sorted2 = (c < d) ? d : c;

    assign data_out[3:0] = (temp1 < sorted1) ? temp1 : sorted1;
    assign data_out[7:4] = (temp1 < sorted1) ? sorted1 : temp1;
    
    assign data_out[11:8] = (temp2 < sorted2) ? temp2 : sorted2;
    assign data_out[15:12] = (temp2 < sorted2) ? sorted2 : temp2;
endmodule