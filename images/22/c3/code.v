module instruction_pipeline (
    input clk,
    input rst,
    input [15:0] instruction_in,
    output reg [15:0] instruction_out
);
    reg [1:0] state; // 00: IF, 01: ID, 10: EX
    reg [15:0] instruction_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            instruction_out <= 16'b0;
            instruction_reg <= 16'b0;
        end else begin
            case (state)
                2'b00: begin // IF
                    instruction_reg <= instruction_in; // Fetch instruction
                    state <= 2'b01; // Move to ID
                end
                2'b01: begin // ID
                    // Normally we would decode here, but we will just pass it
                    state <= 2'b10; // Move to EX
                end
                2'b10: begin // EX
                    instruction_out <= instruction_reg; // Execute (pass-through for now)
                    state <= 2'b00; // Go back to IF
                end
                default: state <= 2'b00; // Reset state if invalid
            endcase
        end
    end
endmodule