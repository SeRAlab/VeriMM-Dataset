module four_input_gate (
    input  A1  ,
    input  A2  ,
    input  B1  ,
    input  C1  ,
    output X   
);

    assign X = (A1 & A2) | (~A1 & B1) | (~A1 & ~B1 & C1);

endmodule