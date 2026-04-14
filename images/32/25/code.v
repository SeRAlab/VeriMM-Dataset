module pipelined_processor(  
    input clk,  
    input rst,  
    input[3:0] opcode, // 0000 for ADD, 0001 for SUB  
    input[7:0] operand1,  
    input[7:0] operand2,  
    output reg[7:0] result  
);  
    reg[7:0] IF_ID_operand1, IF_ID_operand2;  
    reg[3:0] IF_ID_opcode;  

    reg[7:0] ID_EX_operand1, ID_EX_operand2;  
    reg[3:0] ID_EX_opcode;  

    reg[7:0] EX_MEM_result;  
    reg[3:0] EX_MEM_opcode;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            // Reset all registers  
            IF_ID_operand1 <= 8'b0;  
            IF_ID_operand2 <= 8'b0;  
            IF_ID_opcode <= 4'b0;  

            ID_EX_operand1 <= 8'b0;  
            ID_EX_operand2 <= 8'b0;  
            ID_EX_opcode <= 4'b0;  

            EX_MEM_result <= 8'b0;  
            EX_MEM_opcode <= 4'b0;  

            result <= 8'b0;  
        end else begin  
            // Stage 1: Instruction Fetch (IF) -> Pass inputs to the next stage  
            IF_ID_operand1 <= operand1;  
            IF_ID_operand2 <= operand2;  
            IF_ID_opcode <= opcode;  

            // Stage 2: Instruction Decode (ID) -> Pass values to EX stage  
            ID_EX_operand1 <= IF_ID_operand1;  
            ID_EX_operand2 <= IF_ID_operand2;  
            ID_EX_opcode <= IF_ID_opcode;  

            // Stage 3: Execute (EX) -> Perform operation  
            if (ID_EX_opcode == 4'b0000) // ADD  
                EX_MEM_result <= ID_EX_operand1 + ID_EX_operand2;  
            else if (ID_EX_opcode == 4'b0001) // SUB  
                EX_MEM_result <= ID_EX_operand1 - ID_EX_operand2;  
            EX_MEM_opcode <= ID_EX_opcode;  

            // Stage 4: Memory Access (MEM) - No operation needed for this example  
            // Stage 5: Write Back (WB) -> Output the result  
            result <= EX_MEM_result;  
        end  
    end  
endmodule