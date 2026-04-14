module top_module(
    input wire [31:0] pc,
    output wire [31:0] pc_plus_four
    );assign pc_plus_four = pc + 4;
endmodule