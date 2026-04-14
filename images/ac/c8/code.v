module ror_32bit(A, shift_amount, Y);
    input [31:0] A;
    input [4:0] shift_amount;
    output [31:0] Y;

    assign Y = (A >> shift_amount) | (A << (32 - shift_amount));
endmodule