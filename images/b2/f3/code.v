module top_module(
    //# {{data|Data Signals}}
    input  A0,
    input  A1,
    output Y ,

    //# {{control|Control Signals}}
    input  S
);wire notS;
    assign notS = ~S;
    assign Y = (notS & A0) | (S & A1);
endmodule