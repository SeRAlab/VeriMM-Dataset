module mux_2_to_1(
    input               sel,
    input   [3:0]       in0,
    input   [3:0]       in1,
    output  [3:0]       out
);

// Multiplexer logic using dataflow modeling
assign out = sel ? in1 : in0;

endmodule