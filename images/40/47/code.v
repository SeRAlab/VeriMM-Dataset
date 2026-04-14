module mux8to1 (
    input wire [7:0] d,      // 8 data inputs
    input wire [2:0] sel,    // 3 select lines
    output wire y            // output
);
    assign y = d[sel];  // Multiplexer implementation
endmodule