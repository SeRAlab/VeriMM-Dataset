module mux_2to1_32bit(
    input [31:0] in0,  // First 32-bit data input.
    input [31:0] in1,  // Second 32-bit data input.
    input sel,         // 1-bit select input.

    output [31:0] out  // 32-bit output.
);

//------------------------------------------------
// Multiplexer operation
assign out = sel ? in1 : in0; // Select in1 if sel is 1, otherwise select in0

endmodule