module mux_2to1 (
    input sel,
    input [7:0] input0,
    input [7:0] input1,
    output [7:0] out
);

    assign out = (sel) ? input1 : input0;

endmodule