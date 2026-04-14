module mux_2to1_4bit(
    input sel,             // Select signal for the multiplexer.
    input [3:0] in0,       // First 4-bit input signal.
    input [3:0] in1,       // Second 4-bit input signal.
    output [3:0] out       // Multiplexer output signal with a data width of 4 bits.
);

assign out = sel ? in1 : in0;    // Output based on select signal.

endmodule