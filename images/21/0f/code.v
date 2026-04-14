module instruction_pipeline (
    input clk,
    input reset,
    input [7:0] instruction_in,
    output reg [7:0] instruction_out
);
    reg [1:0] state; // 0: IF, 1: ID, 2: EX
    reg [7:0] instruction_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            instruction_out <= 0;
            instruction_reg <= 0;
        end else begin
            case (state)
                0: begin // Instruction Fetch
                    instruction_reg <= instruction_in;
                    state <= 1; // Move to ID
                end
                1: begin // Instruction Decode
                    // Decode instruction (For simplification just pass it)
                    state <= 2; // Move to EX
                end
                2: begin // Execute
                    instruction_out <= instruction_reg; // Pass through for now
                    state <= 0; // Back to IF
                end
            endcase
        end
    end
endmodule