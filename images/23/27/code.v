module hazard_free_mux (
    input wire A,
    input wire B,
    input wire Sel,
    output wire Y
);
    wire not_Sel, A_and_not_Sel, B_and_Sel, temp1, temp2;

    not(not_Sel, Sel);
    and(A_and_not_Sel, A, not_Sel);
    and(B_and_Sel, B, Sel);

    // Hazard resolution
    or(temp1, A_and_not_Sel, B_and_Sel);
    or(temp2, A, B);
    and(Y, temp1, temp2);
endmodule