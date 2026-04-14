module instruction_pipeline(
    input clk,
    input rst,
    input [1:0] opcode,
    input [3:0] operand,
    output reg [1:0] current_opcode,
    output reg [3:0] current_operand
);
    reg [1:0] stage;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 2'b00; // Reset to Fetch stage
            current_opcode <= 2'b00;
            current_operand <= 4'b0000;
        end else begin
            case (stage)
                2'b00: begin // Fetch
                    current_opcode <= opcode;
                    current_operand <= operand;
                    stage <= 2'b01; // Move to Decode
                end
                2'b01: begin // Decode
                    stage <= 2'b10; // Move to Execute
                end
                2'b10: begin // Execute
                    stage <= 2'b11; // Move to Memory Access
                end
                2'b11: begin // Memory Access
                    stage <= 2'b00; // Move to Write Back
                end
            endcase
        end
    end
endmodule