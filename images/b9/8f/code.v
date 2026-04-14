module mux_16to1(
    input a0,  input a1,  input a2,  input a3,
    input a4,  input a5,  input a6,  input a7,
    input a8,  input a9,  input a10, input a11,
    input a12, input a13, input a14, input a15,
    input [3:0] sel,  // 4-bit Selection signal.
    output y    // Output signal.
);

assign y = (sel == 4'b0000) ? a0 :
           (sel == 4'b0001) ? a1 :
           (sel == 4'b0010) ? a2 :
           (sel == 4'b0011) ? a3 :
           (sel == 4'b0100) ? a4 :
           (sel == 4'b0101) ? a5 :
           (sel == 4'b0110) ? a6 :
           (sel == 4'b0111) ? a7 :
           (sel == 4'b1000) ? a8 :
           (sel == 4'b1001) ? a9 :
           (sel == 4'b1010) ? a10 :
           (sel == 4'b1011) ? a11 :
           (sel == 4'b1100) ? a12 :
           (sel == 4'b1101) ? a13 :
           (sel == 4'b1110) ? a14 : a15;  // Multiplexer operation.

endmodule