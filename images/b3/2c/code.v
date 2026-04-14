module top_module(
    Y,
    A,
    B,
    C,
    D
);output Y;
    input  A;
    input  B;
    input  C;
    input  D;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Replacing missing module with a behavioral NAND gate for simulation purposes
    wire nand_output;

    assign nand_output = ~(A & B & C & D);
    assign Y = nand_output;

endmodule