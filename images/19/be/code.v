module mux32to1 (
    input wire [31:0] in,   // 32 input lines
    input wire [4:0] sel,   // 5-bit select line
    output wire out         // Output line
);
    assign out = in[sel];   // Select the input based on sel
endmodule