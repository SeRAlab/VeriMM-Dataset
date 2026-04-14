module pipeline_processor (
    input clk,
    input reset,
    input start,
    input [4:0] operand_a,
    input [4:0] operand_b,
    output reg [4:0] result,
    output reg done
);
    reg [4:0] stage_IF, stage_ID, stage_EX, stage_MEM;
    reg [1:0] state; // 00: Idle, 01: Fetch, 10: Decode, 11: Execute

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            result <= 5'b00000;
            done <= 0;
        end else begin
            case (state)
                2'b00: begin // Idle
                    if (start) begin
                        stage_IF <= operand_a; // Fetch Operand A
                        state <= 2'b01;
                    end
                end
                2'b01: begin // Instruction Fetch
                    stage_ID <= stage_IF; // Decode Operand A
                    stage_IF <= operand_b; // Fetch Operand B
                    state <= 2'b10;
                end
                2'b10: begin // Instruction Decode
                    stage_EX <= stage_ID + stage_IF; // Execute Addition
                    state <= 2'b11;
                end
                2'b11: begin // Memory Access
                    result <= stage_EX; // Write Back Result
                    done <= 1; // Indicate completion
                    state <= 2'b00; // Go back to Idle
                end
                default: state <= 2'b00;
            endcase
        end
    end
endmodule