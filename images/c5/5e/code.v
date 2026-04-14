module my_and4 (
    X  ,
    A_N,
    B_N,
    C  ,
    D
);

    // Module ports
    output X  ;
    input  A_N;
    input  B_N;
    input  C  ;
    input  D  ;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire nand0_out;
    wire nand1_out;
    wire nand2_out;
    wire nand3_out;

    // Implement 4-input AND gate using only NAND gates
    nand nand0 (nand0_out, A_N, B_N);
    nand nand1 (nand1_out, C, D);
    nand nand2 (nand2_out, nand0_out, nand1_out);
    nand nand3 (X, nand2_out, nand2_out);

endmodule