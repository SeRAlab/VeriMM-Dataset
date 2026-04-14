module top_module(PB1, EQ, codeS);input PB1, EQ;
    output [3:0] codeS;

    assign codeS[3] = 1;
    assign codeS[2] = 1;

    or(codeS[1], ~EQ, ~PB1);
    or(codeS[0], EQ, ~PB1);

endmodule