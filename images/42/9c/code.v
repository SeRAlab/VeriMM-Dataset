module mux_2to1_8bit(
    input sel,             // Select signal.
    input [7:0] in0,       // 8-bit input 0.
    input [7:0] in1,       // 8-bit input 1.
    output [7:0] out       // 8-bit output.
);

assign out = sel ? in1 : in0;  // Select between in0 and in1 based on sel.

endmodule