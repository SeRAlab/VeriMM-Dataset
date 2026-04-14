module multiplexer_32_to_1 (
    input wire [31:0] in,  // 32 input lines
    input wire [4:0] sel,  // 5-bit select line
    output wire out        // single output line
);
    assign out = in[sel];  // Select the output based on the select line
endmodule