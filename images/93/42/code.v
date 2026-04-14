module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    input B2,
    output X
);wire A2_A3;
    assign A2_A3 = A2 & ~A3;
    
    assign X = (A1 | A2_A3) & B1;

endmodule