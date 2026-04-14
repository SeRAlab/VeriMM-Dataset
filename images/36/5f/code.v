module sr_latch(
    input wire S,
    input wire R,
    output wire Q,
    output wire Qn
);
    wire N1, N2;

    nand NAND1(N1, S, Qn);
    nand NAND2(N2, R, Q);
    
    assign Q = N1;
    assign Qn = N2;
endmodule