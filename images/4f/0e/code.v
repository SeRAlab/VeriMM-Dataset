module jk_flipflop(J, K, CLK, Q);
input J, K, CLK;
output reg Q;

always @(posedge CLK)
    if (J & K)
        Q <= ~Q;
    else if (J)
        Q <= 1;
    else if (K)
        Q <= 0;

endmodule