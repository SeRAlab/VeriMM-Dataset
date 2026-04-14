module merge_sort_4way(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    output [15:0] out
);
    wire [3:0] sorted01[0:3];
    wire [3:0] sorted23[0:3];
    wire [7:0] merged01, merged23;
    
    // Merge in0 and in1
    assign sorted01[0] = (in0 < in1) ? in0 : in1;
    assign sorted01[1] = (in0 < in1) ? in1 : in0;

    // Merge in2 and in3
    assign sorted23[0] = (in2 < in3) ? in2 : in3;
    assign sorted23[1] = (in2 < in3) ? in3 : in2;

    // Merge sorted01 and sorted23
    assign merged01 = {sorted01[0], sorted01[1]};
    assign merged23 = {sorted23[0], sorted23[1]};
    
    assign out[0] = (merged01[3:0] < merged23[3:0]) ? merged01[3:0] : merged23[3:0];
    assign out[1] = (merged01[3:0] < merged23[3:0]) ? merged23[3:0] : merged01[3:0];

    assign out[2] = (merged01[7:4] < merged23[7:4]) ? merged01[7:4] : merged23[7:4];
    assign out[3] = (merged01[7:4] < merged23[7:4]) ? merged23[7:4] : merged01[7:4];

    assign out[4] = (sorted01[0] < sorted23[0]) ? sorted01[0] : sorted23[0];
    assign out[5] = (sorted01[0] < sorted23[0]) ? sorted23[0] : sorted01[0];

    assign out[6] = (sorted01[1] < sorted23[1]) ? sorted01[1] : sorted23[1];
    assign out[7] = (sorted01[1] < sorted23[1]) ? sorted23[1] : sorted01[1];

    assign out[8] = (sorted23[0] < sorted01[0]) ? sorted23[0] : sorted01[0];
    assign out[9] = (sorted23[0] < sorted01[0]) ? sorted01[0] : sorted23[0];

    assign out[10] = (sorted23[1] < sorted01[1]) ? sorted23[1] : sorted01[1];
    assign out[11] = (sorted23[1] < sorted01[1]) ? sorted01[1] : sorted23[1];

    assign out[12] = sorted01[0];
    assign out[13] = sorted01[1];
    assign out[14] = sorted23[0];
    assign out[15] = sorted23[1];

endmodule