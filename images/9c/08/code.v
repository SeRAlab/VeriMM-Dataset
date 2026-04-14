module top_module(
    input logic A,
    input logic B,
    output logic Y
);logic nand_out;
    logic not_A;
    logic not_B;

    not not_A_inst(not_A, A);
    not not_B_inst(not_B, B);
    nand nand_inst(nand_out, not_A, not_B);
    not not_nand_inst(Y, nand_out);

endmodule