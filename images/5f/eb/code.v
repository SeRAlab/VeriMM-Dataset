module mux_2to1(
    input sel,
    input [3:0] in0,
    input [3:0] in1,

    output [3:0] out
);

// Multiplexer logic
assign out = (sel == 1'b0) ? in0 : in1;

endmodule