module top_module(
    input A,
    input B,
    input C,
    input D,
    output Z
);// Local signals
    wire nand_out;

    // Instantiating a 4-input NAND gate using a combination of 2-input NAND gates
    wire nand_ab;
    wire nand_cd;

    assign nand_ab = ~(A & B);
    assign nand_cd = ~(C & D);
    
    assign nand_out = ~(nand_ab & nand_cd);

    // Assigning the output
    assign Z = nand_out;

endmodule