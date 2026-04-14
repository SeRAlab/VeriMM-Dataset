module AndWithEnable (
    input [7:0] A,
    input [7:0] B,
    input E,
    output [7:0] Y
);
    assign Y = E ? (A & B) : 8'b00000000;
endmodule