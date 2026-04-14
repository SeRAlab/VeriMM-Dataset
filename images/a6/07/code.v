module top_module(
    output X   ,
    input  A1  ,
    input  A2  ,
    input  B1  ,
    input  C1  ,
    input  VPWR,
    input  VGND
);wire not_A1, not_A2, not_B1, not_C1;
    wire A1_and_not_B1, A2_and_not_C1;

    // Invert inputs
    not u_not_A1 (not_A1, A1);
    not u_not_A2 (not_A2, A2);
    not u_not_B1 (not_B1, B1);
    not u_not_C1 (not_C1, C1);

    // Calculate A1 AND NOT B1
    and u_A1_and_not_B1 (A1_and_not_B1, A1, not_B1);

    // Calculate A2 AND NOT C1
    and u_A2_and_not_C1 (A2_and_not_C1, A2, not_C1);

    // Calculate output
    or u_or_gate (X, A1_and_not_B1, A2_and_not_C1);

endmodule