module top_module(
    Y   ,
    A   ,
    B   ,
    C   ,
    D   
);// Module ports
    output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;

    // Local signals
    wire nand0_out;
    wire nand1_out;
    wire nand2_out;
    wire nand3_out;
    wire or0_out;
    wire not0_out;
    wire not1_out;

    // Implement NAND gate using De Morgan's theorem
    nand nand0 (nand0_out, A, B);
    nand nand1 (nand1_out, C, D);
    nand nand2 (nand2_out, nand0_out, nand1_out);
    nand nand3 (nand3_out, nand2_out, nand2_out);
    not  not0  (not0_out, nand3_out);
    not  not1  (Y, not0_out);

endmodule