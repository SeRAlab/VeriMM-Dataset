module pipelined_processor (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] result_out
);

    reg [31:0] IF_ID_instr;
    reg [31:0] ID_EX_operand1, ID_EX_operand2;
    reg [31:0] EX_MEM_result;
    reg [31:0] MEM_WB_result;

    reg stall;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instr <= 0;
            ID_EX_operand1 <= 0;
            ID_EX_operand2 <= 0;
            EX_MEM_result <= 0;
            MEM_WB_result <= 0;
            stall <= 0;
            result_out <= 0;
        end else begin
            // Instruction Fetch
            IF_ID_instr <= instruction_in;

            // Instruction Decode
            if (!stall) begin
                ID_EX_operand1 <= IF_ID_instr[15:0]; // Example operand extraction
                ID_EX_operand2 <= IF_ID_instr[31:16]; // Example operand extraction
            end

            // Execute
            EX_MEM_result <= ID_EX_operand1 + ID_EX_operand2; // Example ADD operation

            // Memory Access
            MEM_WB_result <= EX_MEM_result; // Pass result to Write Back

            // Write Back
            result_out <= MEM_WB_result;

            // Simple hazard detection (stall)
            if (ID_EX_operand1 == ID_EX_operand2) begin
                stall <= 1;
            end else begin
                stall <= 0;
            end
        end
    end
endmodule