module top_module(
    input [3:0] in,   // value to be shifted
    input [1:0] shift, // number of bits to shift
    output [3:0] out  // output
);// shifts everything left by shift amount
    assign out = (shift == 0) ? in :
                 (shift == 1) ? {in[2:0], 1'b0} :
                 (shift == 2) ? {in[1:0], 2'b00} :
                 4'b0000; // if shift == 3, output is 0

endmodule