module pipelined_processor (
    input clk,
    input rst,
    input [7:0] data_a,
    input [7:0] data_b,
    input [1:0] op,
    output reg [7:0] result
);
    reg [7:0] stage_1_a, stage_1_b;
    reg [1:0] stage_1_op;
    
    reg [7:0] stage_2_result;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage_1_a <= 8'b0;
            stage_1_b <= 8'b0;
            stage_1_op <= 2'b0;
            stage_2_result <= 8'b0;
            result <= 8'b0;
        end else begin
            // Stage 1: Fetch inputs
            stage_1_a <= data_a;
            stage_1_b <= data_b;
            stage_1_op <= op;
            
            // Stage 2: Execute
            case (stage_1_op)
                2'b00: stage_2_result <= stage_1_a + stage_1_b; // Addition
                2'b01: stage_2_result <= stage_1_a - stage_1_b; // Subtraction
                2'b10: stage_2_result <= stage_2_result;         // NOP
                default: stage_2_result <= 8'b0;
            endcase
            
            // Stage 3: Write back
            result <= stage_2_result;
        end
    end
endmodule