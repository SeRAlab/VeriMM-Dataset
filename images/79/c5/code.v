module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] max_out
);wire [3:0] temp_max;

    // Compare each bit and store the maximum value in temp_max
    assign temp_max[0] = (A[0] > B[0]) ? A[0] : B[0];
    assign temp_max[1] = (A[1] > B[1]) ? A[1] : B[1];
    assign temp_max[2] = (A[2] > B[2]) ? A[2] : B[2];
    assign temp_max[3] = (A[3] > B[3]) ? A[3] : B[3];

    // Assign the temporary maximum value to the output
    assign max_out = temp_max;

endmodule