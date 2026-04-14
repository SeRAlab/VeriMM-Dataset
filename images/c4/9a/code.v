module logic_circuit (
    output Y   ,
    input  A1_N,
    input  A2_N,
    input  B1  ,
    input  B2  
);

    assign Y = (!A1_N & !A2_N & !B1 & !B2) | (!A1_N & !A2_N & !B1 & B2) | (!A1_N & !A2_N & B1 & !B2) | (!A1_N & !A2_N & B1 & B2) | (!A1_N & A2_N & !B1 & B2) | (!A1_N & A2_N & B1 & !B2) | (!A1_N & A2_N & B1 & B2) | (A1_N & !A2_N & B1 & !B2) | (A1_N & !A2_N & B1 & B2) | (A1_N & A2_N & !B1 & !B2) | (A1_N & A2_N & !B1 & B2) | (A1_N & A2_N & B1 & !B2) | (A1_N & A2_N & B1 & B2);

endmodule