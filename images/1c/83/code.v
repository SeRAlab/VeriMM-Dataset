module pipelined_processor (  
    input clk,  
    input rst,  
    input [1:0] opcode,  
    input [31:0] operand1,  
    input [31:0] operand2,  
    output reg [31:0] result  
);  
    reg [31:0] IF_op1, IF_op2;  
    reg [1:0] ID_opcode;  
    reg [31:0] EX_result;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            result <= 0;  
        end else begin  
            // Stage 1: Instruction Fetch  
            IF_op1 <= operand1;  
            IF_op2 <= operand2;  
            
            // Stage 2: Instruction Decode  
            ID_opcode <= opcode;  
            
            // Stage 3: Execute  
            case (ID_opcode)  
                2'b00: EX_result <= IF_op1 + IF_op2; // Addition  
                2'b01: EX_result <= IF_op1 - IF_op2; // Subtraction  
                default: EX_result <= 0;  
            endcase  

            // Stage 4: Memory Access (not used here, just passing the result)  
            
            // Stage 5: Write Back  
            result <= EX_result;  
        end  
    end  
endmodule