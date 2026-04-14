module mux2to1(
    input [7:0] in0,
    input [7:0] in1,
    input sel,
    output [7:0] out
);

    assign out = sel ? in1 : in0;

endmodule