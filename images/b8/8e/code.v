module multiplexer_2bit_2to1 (
    input sel,
    input [1:0] in0,
    input [1:0] in1,
    output [1:0] out
);

    assign out = sel ? in1 : in0;

endmodule