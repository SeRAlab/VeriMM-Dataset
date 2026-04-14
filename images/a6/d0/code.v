module top_module(
    input wire [31:0] SE32_out,
    output wire [31:0] Shifleft2_out
);assign Shifleft2_out = SE32_out << 2; 

endmodule