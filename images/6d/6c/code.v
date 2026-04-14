module mux_2to1_4bit(
    input [3:0] in0,
    input [3:0] in1,
    input sel,
    output [3:0] out
);

    assign out = sel ? in1 : in0;

endmodule