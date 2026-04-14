module top_module(
    input logic A,
    input logic B,
    input logic C,
    input logic D,
    output logic Y
);logic n1, n2, n3, n4;

    assign n1 = ~(A & B);
    assign n2 = ~(C & D);
    assign n3 = ~(n1 & n2);
    assign Y = ~n3;

endmodule