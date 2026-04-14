module top_module(D, S, R, CLK, Q);parameter INIT = 1'b0;
    input D, S, R, CLK;
    output Q;

    wire nS, nR, nD, nQ;

    nand(nS, S, CLK);
    nand(nR, R, CLK);
    nand(nD, D, CLK);
    nand(nQ, nR, nQ);
    nand(nQ, nD, nS);

    assign Q = (INIT) ? nQ : ~nQ;
endmodule