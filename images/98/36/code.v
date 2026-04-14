module not_32bit(A, Y);
    input [31:0] A;
    output [31:0] Y;

    assign Y = ~A;
endmodule