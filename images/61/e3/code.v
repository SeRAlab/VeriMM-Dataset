module multiplexer_32bit_2to1 (
    input sel,
    input [31:0] in0,
    input [31:0] in1,
    output [31:0] out
);

    assign out = sel ? in1 : in0;

endmodule