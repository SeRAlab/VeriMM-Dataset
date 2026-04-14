module pipelined_processor (
    input clk,
    input rst,
    input [4:0] input_a,
    input [4:0] input_b,
    input [1:0] opcode,
    output reg [4:0] result,
    output reg valid
);
    reg [4:0] stage_id_a, stage_id_b;
    reg [1:0] stage_id_opcode;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage_id_a <= 5'd0;
            stage_id_b <= 5'd0;
            stage_id_opcode <= 2'b00;
            result <= 5'd0;
            valid <= 1'b0;
        end else begin
            // Stage IF to ID
            stage_id_a <= input_a;
            stage_id_b <= input_b;
            stage_id_opcode <= opcode;
            
            // Stage ID to EX
            if (stage_id_opcode == 2'b00) begin // ADD
                result <= stage_id_a + stage_id_b;
                valid <= 1'b1;
            end else begin // NOP
                result <= result;
                valid <= 1'b0;
            end
        end
    end
endmodule