module instruction_pipeline (
    input clk,
    input rst,
    input [3:0] instruction_in, // 4-bit instruction input
    output reg [3:0] instruction_out // output instruction after processing
);
    reg [3:0] stage1; // Fetch stage
    reg [3:0] stage2; // Decode stage
    reg [3:0] stage3; // Execute stage
    reg stall; // Stall signal

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 4'b0000;
            stage2 <= 4'b0000;
            stage3 <= 4'b0000;
            instruction_out <= 4'b0000;
            stall <= 0;
        end else begin
            if (!stall) begin
                stage1 <= instruction_in; // Fetch
                stage2 <= stage1; // Decode
                stage3 <= stage2; // Execute
                instruction_out <= stage3; // Output
            end else begin
                // If stalled, hold the previous values
                instruction_out <= stage3; // Keep output from the last executed instruction
            end

            // Simple hazard detection: stall if instruction is 4'b1111 (example)
            stall <= (stage1 == 4'b1111);
        end
    end
endmodule