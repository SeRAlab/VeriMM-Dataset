module pipeline_processor(
    input clk,
    input reset,
    input [7:0] instruction,
    output reg [7:0] result
);
    reg [7:0] IF_instruction;
    reg [7:0] ID_instruction;
    reg [7:0] EX_result;
    reg [7:0] MEM_data;
    reg [2:0] opcode;
    reg [4:0] operand1, operand2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_instruction <= 8'b0;
            ID_instruction <= 8'b0;
            EX_result <= 8'b0;
            MEM_data <= 8'b0;
            result <= 8'b0;
        end else begin
            // Stage 1: Instruction Fetch
            IF_instruction <= instruction;

            // Stage 2: Instruction Decode
            ID_instruction <= IF_instruction;
            opcode <= ID_instruction[7:5];
            operand1 <= ID_instruction[4:0];

            // Stage 3: Execute
            case (opcode)
                3'b000: EX_result <= operand1 + operand2; // ADD
                3'b001: EX_result <= operand1 - operand2; // SUB
                3'b010: EX_result <= operand1 & operand2; // AND
                3'b011: EX_result <= operand1 | operand2; // OR
                default: EX_result <= 8'b0;
            endcase

            // Stage 4: Memory Access
            MEM_data <= EX_result;

            // Stage 5: Write Back
            result <= MEM_data;
        end
    end
endmodule