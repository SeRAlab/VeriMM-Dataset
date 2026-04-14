module pipelined_processor (
    input clk,
    input reset,
    input [31:0] instruction_in,
    input [31:0] data_in,
    output reg [31:0] result_out,
    output reg [31:0] address_out,
    output reg mem_read,
    output reg mem_write
);

reg [31:0] instruction_reg;
reg [31:0] operand1, operand2;
reg [31:0] alu_result;
reg [4:0] opcode;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        instruction_reg <= 0;
        operand1 <= 0;
        operand2 <= 0;
        alu_result <= 0;
        result_out <= 0;
        address_out <= 0;
        mem_read <= 0;
        mem_write <= 0;
    end else begin
        // Stage 1: Instruction Fetch
        instruction_reg <= instruction_in;

        // Stage 2: Instruction Decode
        opcode <= instruction_reg[31:27]; // Assuming 5-bit opcode
        operand1 <= instruction_reg[26:21]; // Source 1
        operand2 <= instruction_reg[20:15]; // Source 2

        // Stage 3: Execute
        case (opcode)
            5'b00001: alu_result <= operand1 + operand2; // Example: ADD
            5'b00010: alu_result <= operand1 - operand2; // Example: SUB
            default: alu_result <= 0;
        endcase

        // Stage 4: Memory Access
        address_out <= alu_result; // Assume ALU result is the memory address
        mem_read <= (opcode == 5'b00011); // Example: LOAD
        mem_write <= (opcode == 5'b00100); // Example: STORE

        // Stage 5: Write Back
        if (mem_write) begin
            // Write data to memory (not implemented, just simulation)
        end else if (mem_read) begin
            result_out <= data_in; // Read data from memory
        end else begin
            result_out <= alu_result; // Result from ALU operation
        end
    end
end

endmodule