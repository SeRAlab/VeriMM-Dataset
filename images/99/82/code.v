module top_module(
    A,
    B,
    Cin,
    Sum,
    Cout,
    V
);input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] Sum;
    output Cout;
    output V;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire c1, c2, c3;

    // Use built-in XOR gates
    assign c1 = A[0] ^ B[0] ^ Cin;
    assign c2 = A[1] ^ B[1] ^ (A[0] & B[0]);
    assign c3 = A[2] ^ B[2] ^ (c1 & (A[1] & B[1]));

    assign Sum[0] = c1;
    assign Sum[1] = c2;
    assign Sum[2] = c3;

    // Compute carry out
    assign Cout = (A[0] & B[0]) | (c1 & Cin);
    
    // Compute V (overflow)
    assign V = (Cout ^ Cin);

    // Assign Sum[3] for completeness, assuming it's an external source
    assign Sum[3] = 0; // Or connect to any specific logic as needed

endmodule