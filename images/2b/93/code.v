module instruction_pipeline (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] result_out
);

    reg [31:0] instruction_F;
    reg [31:0] instruction_D;
    reg [31:0] instruction_E;
    reg [31:0] result_E;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_F <= 0;
            instruction_D <= 0;
            instruction_E <= 0;
            result_out <= 0;
        end else begin
            // Stage 1: Fetch
            instruction_F <= instruction_in; // Fetch instruction
            
            // Stage 2: Decode
            instruction_D <= instruction_F; // Pass instruction to Decode
            
            // Stage 3: Execute
            instruction_E <= instruction_D; // Pass instruction to Execute
            result_E <= instruction_E + 1; // Example: increment instruction for result
            
            // Output the result of the Execute stage
            result_out <= result_E;
        end
    end
endmodule