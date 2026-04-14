module nand_gate (
    input A,
    input B,
    output X
);

    assign X = ~(A & B);

endmodule

module and_gate (
    input A,
    input B,
    output X
);

    wire nand1_out;
    wire nand2_out;

    nand_gate nand1(.A(A), .B(A), .X(nand1_out));
    nand_gate nand2(.A(B), .B(B), .X(nand2_out));
    nand_gate nand3(.A(nand1_out), .B(nand2_out), .X(X));

endmodule