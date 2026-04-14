module FIR_Filter (
    input [15:0] x0,  // Input sample 0
    input [15:0] x1,  // Input sample 1
    input [15:0] x2,  // Input sample 2
    input [15:0] x3,  // Input sample 3
    output [31:0] y   // Output sample
);
    assign y = (x0 * 1) + (x1 * 2) + (x2 * 3) + (x3 * 4);
endmodule