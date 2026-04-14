module top_module(
    input A1,
    input A2,
    input B1_N,
    output X
);wire A1_A2_and;
    wire A1_not;
    wire A2_not;
    wire B1_not;
    wire A1_and_B1_not;
    wire A2_and_B1;
    
    assign A1_A2_and = A1 & A2;
    assign A1_not = ~A1;
    assign A2_not = ~A2;
    assign B1_not = ~B1_N;
    assign A1_and_B1_not = A1 & B1_not;
    assign A2_and_B1 = A2 & B1_N;
    
    assign X = (A1_A2_and) ? 1 :
               (A1_not & A2_not & B1_not) ? 0 :
               (A1_not & A2 & B1_not) ? B1_N :
               (A2_not & A1 & B1_N) ? B1_not :
               (A1_and_B1_not | A2_and_B1);
               
endmodule