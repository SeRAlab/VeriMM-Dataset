module top_module(
    Y ,
    A1,
    A2,
    B1,
    C1,
    D1
);// Module ports
    output Y ;
    input  A1;
    input  A2;
    input  B1;
    input  C1;
    input  D1;

    // Local signals
    wire and0_out;
    wire and1_out;
    wire xor0_out;
    wire xor1_out;
    wire not0_out;
    wire not1_out;
    wire and2_out;
    wire or0_out;
    wire nand0_out_Y;

    //   Name   Output       Other arguments
    and and0 (and0_out, A1, A2);
    xor xor0 (xor0_out, A1, A2);
    not not0 (not0_out, D1);
    xor xor1 (xor1_out, B1, C1);
    and and1 (and1_out, B1, C1);
    not not1 (not1_out, xor1_out);
    and and2 (and2_out, not1_out, D1);
    or or0   (or0_out, and0_out, xor0_out);
    nand nand0 (nand0_out_Y, and2_out, or0_out);

    buf buf0 (Y, nand0_out_Y);

endmodule