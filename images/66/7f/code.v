module top_module(
    input wire clock,
    input wire WriteEnable,
    input wire Flush,
    input wire [31:0] pc_plus_four,
    output reg [31:0] ID_pc_plus_four,
    input wire [31:0] instruction,
    output reg [31:0] ID_instruction
    );always @(negedge clock) begin
        if (Flush) begin
            
            
            
            
            ID_pc_plus_four <= 0;
            ID_instruction <= 0;
        end
        else if (WriteEnable) begin
            ID_pc_plus_four <= pc_plus_four;
            ID_instruction <= instruction;
        end
    end  
endmodule