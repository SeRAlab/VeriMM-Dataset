module instruction_pipeline (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out
);
    // Define the stages of the pipeline
    reg [31:0] IF_ID, ID_EX, EX_MEM, MEM_WB;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID <= 32'b0;
            ID_EX <= 32'b0;
            EX_MEM <= 32'b0;
            MEM_WB <= 32'b0;
            instruction_out <= 32'b0;
        end else begin
            // Pipeline stages
            IF_ID <= instruction_in;       // Instruction Fetch
            ID_EX <= IF_ID;                // Instruction Decode
            EX_MEM <= ID_EX;               // Execute
            MEM_WB <= EX_MEM;              // Memory Access
            instruction_out <= MEM_WB;     // Write Back
        end
    end
endmodule