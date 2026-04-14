module top_module(
    input [31:0] jump_address,
    input [31:0] from_mux_branch,
    input jump,
    output reg [31:0] to_pc
);always @(*) begin
    if (jump) begin
        to_pc = jump_address;
    end else begin
        to_pc = from_mux_branch;
    end
end

endmodule