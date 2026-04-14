module top_module(A, B, S0, S1, Z);input A;
    input B;
    input S0;
    input S1;
    output Z;
    
    wire not_S0, not_S1, not_A, not_B;
    wire A_and_not_B, not_A_and_B, not_A_and_not_B, not_B_and_A;

    not (not_S0, S0);
    not (not_S1, S1);
    not (not_A, A);
    not (not_B, B);
    
    and (A_and_not_B, A, not_B);
    and (not_A_and_B, not_A, B);
    and (not_A_and_not_B, not_A, not_B);
    and (not_B_and_A, not_B, A);
    
    or (Z, (A_and_not_B & not_S1 & not_S0), (not_A_and_B & S1 & not_S0), 
                (not_A_and_not_B & S1 & S0), (not_B_and_A & not_S1 & S0));

endmodule