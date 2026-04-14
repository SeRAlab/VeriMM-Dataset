module top_module(A, B, S, Y);input [3:0] A;
    input [3:0] B;
    input S;
    output [3:0] Y;

    assign Y = S ? B : A;
endmodule