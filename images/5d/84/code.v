module top_module( 
    input [63:0] in,        // 64-bit input vector containing 16 4-bit inputs
    input [3:0] sel,        // Selects which 4-bit input to output
    output out              // Output signal that is set high if the selected 4-bit input matches the fixed 4-bit value, otherwise set low
);// Multiplexer implementation
    wire [3:0] mux_out;     // Output of the multiplexer
    
    // Selecting the corresponding 4-bit input based on the 4-bit selector
    assign mux_out = in[sel*4 +: 4];  // Using the selected bits from input vector

    // Compare with fixed 4-bit value (for example, 4'b1001)
    assign out = (mux_out == 4'b1001) ? 1'b1 : 1'b0;  // Output high if mux_out matches 4'b1001, otherwise low.

endmodule