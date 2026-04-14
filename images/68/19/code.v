module top_module(
    input [1:0] sel,
    input A,
    input B,
    output Y
);wire xor_out;
    wire and_out;
    wire or_out;
    wire nand_out;

    assign xor_out = A ^ B;
    assign and_out = A & B;
    assign or_out = A | B;
    assign nand_out = ~(A & B);

    assign Y = (sel == 0) ? xor_out :
               (sel == 1) ? and_out :
               (sel == 2) ? or_out :
                            nand_out;

endmodule