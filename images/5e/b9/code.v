module top_module(
    input A,
    input B,
    input Cin,
    output reg Sum,
    output reg Cout
);wire a_and_b;
    wire a_xor_b;
    wire a_and_b_and_cin;
    wire a_xor_b_xor_cin;

    // Generic NAND gate definition
    wire nand1_out, nand2_out, nand3_out, nand4_out, nand5_out, nand6_out;

    assign nand1_out = ~(A & B);
    assign nand2_out = ~(A & nand1_out);
    assign nand3_out = ~(nand2_out & Cin);
    assign nand4_out = ~(nand1_out & Cin);
    assign nand5_out = ~(nand4_out & nand3_out);
    assign nand6_out = ~(nand2_out & nand4_out);

    assign Cout = nand5_out;  // Updated logic for Cout
    assign Sum = nand6_out;    // Updated logic for Sum

endmodule