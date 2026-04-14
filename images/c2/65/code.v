module bitwise_and(
    input [7:0] in,
    output [7:0] out
);

    assign out = in & 8'b11100011;

endmodule