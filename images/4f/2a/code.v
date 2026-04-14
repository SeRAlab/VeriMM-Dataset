module mux2_1(
    input sel,         // Select signal. Defined as 0 to select input a; defined as 1 to select input b.
    input [7:0] a,     // 8-bit input signal a.
    input [7:0] b,     // 8-bit input signal b.

    output [7:0] y     // 8-bit output signal.
);

assign y = (sel) ? b : a; // Select input based on sel signal

endmodule