module top_module(
    IN,
    OUT,
    VPWR,
    VGND,
    VPB,
    VNB 
);input [3:0] IN;
    output OUT;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    wire [3:0] nand_out;
    wire [2:0] level1_out;
    wire [1:0] level2_out;
    wire level3_out;

    // Updated to use an equivalent logic gate
    // Assuming a 3-input NAND gate, if library is missing, you can define it 
    // or replace it with built-in Verilog primitives
    nand NAND1 (
        nand_out[0], 
        ~IN[0], 
        IN[1], 
        IN[2]
    );

    nand NAND2 (
        nand_out[1], 
        ~IN[1], 
        IN[2], 
        IN[3]
    );

    nand NAND3 (
        nand_out[2], 
        ~IN[2], 
        IN[3], 
        IN[0]
    );

    nand NAND4 (
        nand_out[3], 
        ~IN[3], 
        IN[0], 
        IN[1]
    );

    assign level1_out[0] = nand_out[0] & nand_out[1];
    assign level1_out[1] = nand_out[1] & nand_out[2];
    assign level1_out[2] = nand_out[2] & nand_out[3];

    assign level2_out[0] = level1_out[0] & level1_out[1];
    assign level2_out[1] = level1_out[1] & level1_out[2];

    assign level3_out = level2_out[0] & level2_out[1];

    assign OUT = ~level3_out;

endmodule