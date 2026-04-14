module pipeline_processor(
    input clk,
    input reset,
    input [4:0] instruction,
    input [4:0] operand1,
    input [4:0] operand2,
    output reg [4:0] result
);
    reg [4:0] stage [0:6];
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 5'b0;
            stage[0] <= 5'b0;
            stage[1] <= 5'b0;
            stage[2] <= 5'b0;
            stage[3] <= 5'b0;
            stage[4] <= 5'b0;
            stage[5] <= 5'b0;
            stage[6] <= 5'b0;
        end else begin
            stage[0] <= instruction;
            stage[1] <= stage[0];
            stage[2] <= stage[1];
            stage[3] <= stage[2];
            stage[4] <= stage[3];
            stage[5] <= stage[4];
            stage[6] <= stage[5];
            
            case(stage[6][4:0])
                5'b00001: result <= operand1 + operand2; // ADD
                5'b00010: result <= operand1 - operand2; // SUB
                5'b00011: result <= operand1 & operand2; // AND
                5'b00100: result <= operand1 | operand2; // OR
                5'b00101: result <= operand1 ^ operand2; // XOR
                5'b00110: result <= operand1; // LD
                5'b00111: result <= 5'b0; // ST (no output)
                default: result <= 5'b0; // NOP or invalid
            endcase
        end
    end
endmodule