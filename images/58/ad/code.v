module top_module(
    input  A_N ,
    input  B_N ,
    input  C   ,
    input  D   ,
    output Y   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);// Define internal signals
    wire  AB_N;
    wire  CD_N;
    wire  Y_N;

    // Implement the NAND gate
    assign AB_N = ~(A_N & B_N);
    assign CD_N = ~(C & D);
    assign Y_N  = ~(AB_N & CD_N);
    assign Y    = Y_N;

endmodule