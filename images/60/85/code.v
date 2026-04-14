module top_module(
    A,
    B,
    O
);input [8:0] A;
input [8:0] B;
output [9:0] O;

wire sig_33,sig_34,sig_36,sig_43,sig_46,sig_48,sig_69,sig_75,sig_76;

assign sig_33 = A[7] | B[7];
assign sig_34 = A[8] & B[8];
assign sig_36 = A[8] ^ B[8];
assign sig_43 = B[8] ^ A[8];
assign sig_46 = sig_43 & A[7];
assign sig_48 = sig_34 | sig_46;
assign sig_69 = sig_33 ^ A[7];
assign sig_75 = sig_36 ^ A[7];
assign sig_76 = sig_36 ^ sig_48;

assign O[9] = sig_76;
assign O[8] = sig_75;
assign O[7] = sig_69;
assign O[6] = sig_76;
assign O[5] = sig_76;
assign O[4] = sig_76;
assign O[3] = 1'b0;
assign O[2] = sig_69;
assign O[1] = sig_76;
assign O[0] = sig_69;

endmodule