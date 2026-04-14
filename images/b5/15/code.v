module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);wire [3:0] xor1_out;
    wire [3:0] and1_out;
    wire [3:0] xor2_out;
    wire [3:0] and2_out;
    wire [3:0] and3_out;
    wire and4_out;
    wire and5_out;
    wire and6_out;
    wire and7_out;
    wire and8_out;
    wire and9_out;
    wire and10_out;
    wire and11_out;
    wire and12_out;
    
    // First bit
    xor xor1(xor1_out[0], A[0], B[0], Cin);
    and and1(and1_out[0], A[0], B[0]);
    and and2(and2_out[0], A[0], Cin);
    xor xor2(Sum[0], xor1_out[0], and1_out[0], and2_out[0]);
    
    wire or1_out0;
    or or1(or1_out0, and1_out[0], and2_out[0]);
    
    // Combine with carry out
    or or_final0(Cout, or1_out0, and3_out);
    
    // Second bit
    xor xor3(xor1_out[1], A[1], B[1], or1_out0);
    and and4(and4_out, A[1], B[1]);
    and and5(and5_out, A[1], or1_out0);
    xor xor4(Sum[1], xor1_out[1], and4_out, and5_out);

    wire or1_out1;
    or or4(or1_out1, and4_out, and5_out);
    
    // Combine with carry out
    or or_final1(Cout, or1_out1, or_final0);
    
    // Third bit
    xor xor5(xor1_out[2], A[2], B[2], or1_out1);
    and and7(and7_out, A[2], B[2]);
    and and8(and8_out, A[2], or1_out1);
    xor xor6(Sum[2], xor1_out[2], and7_out, and8_out);

    wire or1_out2;
    or or7(or1_out2, and7_out, and8_out);
    
    // Combine with carry out
    or or_final2(Cout, or_final1, or1_out2);
    
    // Fourth bit
    xor xor7(xor1_out[3], A[3], B[3], or1_out2);
    and and10(and10_out, A[3], B[3]);
    and and11(and11_out, A[3], or1_out2);
    xor xor8(Sum[3], xor1_out[3], and10_out, and11_out);

    wire or1_out3;
    or or10(or1_out3, and10_out, and11_out);
    
    // Combine with carry out
    or or_final3(Cout, or_final2, or1_out3);
    
endmodule