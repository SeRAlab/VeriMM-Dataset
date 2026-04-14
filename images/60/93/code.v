module top_module(
    input [1:0] A,
    input [1:0] B,
    input CIN,
    output [1:0] SUM,
    output COUT
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire [1:0] S;
    wire C1, C2;

    // Use a behavioral full adder implementation since the specific module is not recognized
    // First full adder
    assign S[0] = A[0] ^ B[0] ^ CIN;       // SUM bit 0
    assign C1 = (A[0] & B[0]) | (CIN & (A[0] ^ B[0])); // Carry out from first adder

    // Second full adder
    assign S[1] = A[1] ^ B[1] ^ C1;       // SUM bit 1
    assign COUT = (A[1] & B[1]) | (C1 & (A[1] ^ B[1])); // Final carry out

    assign SUM = S; // Assign the sum output

endmodule