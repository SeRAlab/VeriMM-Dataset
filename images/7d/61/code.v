module multiplexer_8bit_2to1 (
    input sel,
    input [7:0] in0,
    input [7:0] in1,
    output [7:0] out
);

    assign out = sel ? in1 : in0;

endmodule