module pipeline_processor (
    input clk,
    input rst,
    input [4:0] instruction_in,
    output reg [4:0] result_out
);
    reg [4:0] IF_stage, ID_stage, EX_stage, MEM_stage, WB_stage;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_stage <= 5'b00000;
            ID_stage <= 5'b00000;
            EX_stage <= 5'b00000;
            MEM_stage <= 5'b00000;
            WB_stage <= 5'b00000;
            result_out <= 5'b00000;
        end else begin
            IF_stage <= instruction_in; // Instruction Fetch
            ID_stage <= IF_stage;        // Instruction Decode
            EX_stage <= (ID_stage != 5'b00000) ? (ID_stage + 1) : 5'b00000; // Execute
            MEM_stage <= EX_stage;       // Memory Access
            WB_stage <= MEM_stage;       // Write Back
            result_out <= WB_stage;      // Output result
        end
    end
endmodule