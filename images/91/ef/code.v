module top_module(
    input [3:0] D0, D1, D2, D3,
    input [1:0] S0, S1,
    output [3:0] Y
);assign Y = (S1 & S0) ? D3 :
               (S1 & ~S0) ? D2 :
               (~S1 & S0) ? D1 :
               (~S1 & ~S0) ? D0 : 4'bX;

endmodule