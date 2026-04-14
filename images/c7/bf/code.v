module bitwise_xor (
    input [31:0] A,
    input [31:0] B,
    input TE,
    output [31:0] Z
);

    assign Z = TE ? (A ^ B) : 0;

endmodule