module mux16to1 (
    input wire [15:0] in,  // 16 input lines
    input wire [3:0] sel,  // 4-bit select line
    output wire out        // output line
);
    assign out = in[sel];   // Select the appropriate input based on the select line
endmodule