module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);wire not_A, not_B, not_C, not_D;
    wire and1_out, and2_out, and3_out, and4_out;
    wire or1_out, or2_out, or3_out;
    wire xor1_out, xor2_out;
    
    not u_not_A(not_A, A);
    not u_not_B(not_B, B);
    not u_not_C(not_C, C);
    not u_not_D(not_D, D);
    
    and u_and1(and1_out, A, not_B, not_C, not_D);
    and u_and2(and2_out, not_A, B, not_C, not_D);
    and u_and3(and3_out, not_A, not_B, C, not_D);
    and u_and4(and4_out, not_A, not_B, not_C, D);
    
    or u_or1(or1_out, and1_out, and2_out);
    or u_or2(or2_out, or1_out, and3_out);
    or u_or3(or3_out, or2_out, and4_out);
    
    xor u_xor1(xor1_out, A, B);
    xor u_xor2(xor2_out, C, D);
    
    or u_or4(Y, xor1_out, xor2_out, or3_out);
    
endmodule