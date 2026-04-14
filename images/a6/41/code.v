module rshift_32bit(A, Shift, Y);
    input [31:0] A;
    input [4:0] Shift;
    output [31:0] Y;

    assign Y = A >> Shift;
endmodule