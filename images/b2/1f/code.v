module top_module(
    input clk,
    input rst,
    input en,
    input en_mem,
    input mem_wait,
    input should_branch,
    input imm,
    output reg [8:0] control_o,
    output reg [1:0] pc_op
);always @(posedge clk) begin
        if (rst) begin
            control_o <= 0;
            pc_op <= 0;
        end else if (en) begin
            // Control signal generation
            control_o[0] <= en_mem;
            control_o[1] <= should_branch;
            control_o[2] <= imm;
            
            // Opcode signal generation
            if (imm) begin
                pc_op <= 2'b10; // Bitwise AND
            end else begin
                pc_op <= 2'b00; // Add
            end
        end
    end
endmodule