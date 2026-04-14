module top_module(
    input A1_N,
    input A2_N,
    input B1,
    input B2,
    output S1,
    output S2
);wire C1, C2, C3;
    
    xor(S2, A2_N, B2);
    xor(S1, A1_N, B1);
    and(C1, A1_N, B1);
    and(C2, A2_N, B2);
    and(C3, S1, S2);
    or(S2, C1, C2, C3);
    
endmodule