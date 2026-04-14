module mux32to1 (
    input [31:0] in,   // 32-bit input
    input [4:0] sel,   // 5-bit select line
    output out          // output
);

assign out = in[sel]; // Select the corresponding input based on the select line

endmodule