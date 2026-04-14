module twos_complement (
    input [3:0] A,
    output [3:0] Y
);

    assign Y = ~A + 1;

endmodule