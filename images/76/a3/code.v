module top_module(
    input A,
    input B,
    input C,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output X
);wire ab, bc, ac;
    wire ab_bc, ab_ac, bc_ac;
    
    // AND gates
    and and1 (ab, A, B);
    and and2 (bc, B, C);
    and and3 (ac, A, C);
    
    // OR gates
    or or1 (ab_bc, ab, bc);
    or or2 (ab_ac, ab, ac);
    or or3 (bc_ac, bc, ac);
    
    // Final OR gate
    or or4 (X, ab_bc, ab_ac, bc_ac);
    
    // Power and ground supply pins
    assign VGND = 0;
    assign VPWR = 1;
    assign VPB = 1;
    assign VNB = 0;
    
endmodule