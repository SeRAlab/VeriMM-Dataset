module instruction_pipeline (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out
);
    reg [31:0] IF_stage, ID_stage, EX_stage;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_stage <= 32'b0;
            ID_stage <= 32'b0;
            EX_stage <= 32'b0;
            instruction_out <= 32'b0;
        end else begin
            IF_stage <= instruction_in; // Instruction Fetch
            ID_stage <= IF_stage;        // Instruction Decode
            EX_stage <= ID_stage;        // Execute
            instruction_out <= EX_stage; // Write Back
        end
    end
endmodule