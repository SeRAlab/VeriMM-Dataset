module bitwise_and (
    input [7:0] A,
    input [7:0] B,
    input EN,
    output [7:0] Y
);
    assign Y = (EN) ? (A & B) : 8'b00000000;
endmodule