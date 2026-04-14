module and_gate (
    input  A1  ,
    input  A2  ,
    input  A3  ,
    input  A4  ,
    output X   
);

wire w1, w2, w3;

and(w1, A1, A2);
and(w2, A3, A4);
and(w3, w1, w2);
assign X = w3;

endmodule