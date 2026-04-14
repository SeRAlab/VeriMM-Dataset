module top_module(
    input A,
    input B,
    input S,
    output Y
);wire not_S;
    assign not_S = ~S;
    
    wire Y_A;
    wire Y_B;
    
    and gate_A(A, not_S, Y_A);
    and gate_B(B, S, Y_B);
    
    or gate_C(Y_A, Y_B, Y);

endmodule