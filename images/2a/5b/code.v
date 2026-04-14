module pipelined_processor (
    input clk,
    input rst,
    input [31:0] instruction,
    output reg [31:0] processed_instruction,
    output reg [2:0] current_stage // 0: Fetch, 1: Decode, 2: Execute, 3: Memory Access, 4: Write Back, 5: Hazard Detection, 6: Commit
);
    reg [2:0] stage;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            processed_instruction <= 0;
        end else begin
            case (stage)
                0: begin // Fetch
                    processed_instruction <= instruction;
                    stage <= stage + 1;
                end
                1: begin // Decode
                    // Decoding logic (for simplicity, just passing it through)
                    stage <= stage + 1;
                end
                2: begin // Execute
                    // Execution logic (for simplicity, just passing it through)
                    stage <= stage + 1;
                end
                3: begin // Memory Access
                    // Memory access logic (for simplicity, just passing it through)
                    stage <= stage + 1;
                end
                4: begin // Write Back
                    // Write back logic (for simplicity, just passing it through)
                    stage <= stage + 1;
                end
                5: begin // Hazard Detection
                    // Hazard detection logic (for simplicity, just passing it through)
                    stage <= stage + 1;
                end
                6: begin // Commit
                    // Commit logic (for simplicity, just passing it through)
                    stage <= 0; // Reset to fetch
                end
            endcase
        end
    end

    always @(*) begin
        current_stage = stage;
    end
endmodule