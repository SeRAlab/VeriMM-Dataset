module merge_sort (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] sorted0,
    output [7:0] sorted1,
    output [7:0] sorted2,
    output [7:0] sorted3
);

wire [7:0] temp1, temp2, temp3, temp4;

// First stage of sorting
assign temp1 = (a < b) ? a : b;
assign temp2 = (a < b) ? b : a;
assign temp3 = (c < d) ? c : d;
assign temp4 = (c < d) ? d : c;

// Second stage of sorting
assign sorted0 = (temp1 < temp3) ? temp1 : temp3;
assign sorted1 = (temp1 < temp3) ? (temp2 < temp3 ? temp2 : temp3) : (temp2 < temp1 ? temp1 : temp2);
assign sorted2 = (temp1 < temp3) ? (temp2 < temp3 ? temp3 : temp2) : (temp2 < temp1 ? temp1 : temp2);
assign sorted3 = (temp1 < temp3) ? temp4 : temp3;

endmodule