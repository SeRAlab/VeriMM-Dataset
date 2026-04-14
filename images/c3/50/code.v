module three_input_gate (
    input A1,
    input A2,
    input B1,
    output X
);

    wire A1_not;
    wire A2_not;
    wire A1_and_A2;
    wire A1_nand_A2;
    wire B1_not;
    wire A1_and_A2_nand_B1;
    
    assign A1_not = ~A1;
    assign A2_not = ~A2;
    assign A1_and_A2 = A1 & A2;
    assign A1_nand_A2 = ~(A1 & A2);
    assign B1_not = ~B1;
    assign A1_and_A2_nand_B1 = ~(A1 & A2 & B1);

    assign X = (A1 & A2_not) | (A1_not & A2) | (B1_not & A1_and_A2_nand_B1);

endmodule