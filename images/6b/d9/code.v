module mux_4to1(
    input [3:0] a,    // Input signal a with a data width of 4 bits.
    input [3:0] b,    // Input signal b with a data width of 4 bits.
    input [3:0] c,    // Input signal c with a data width of 4 bits.
    input [3:0] d,    // Input signal d with a data width of 4 bits.
    input [1:0] sel,  // 2-bit Selection signal.
    output [3:0] y    // Output signal with a data width of 4 bits.
);

assign y = (sel == 2'b00) ? a : 
           (sel == 2'b01) ? b :
           (sel == 2'b10) ? c : d;  // Multiplexer operation.

endmodule