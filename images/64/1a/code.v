module top_module(
    input wire [31:0] pc_plus_four,
    input wire [31:0] extended_times_four,
    output wire [31:0] branch_address
    );assign branch_address = pc_plus_four + extended_times_four;
endmodule