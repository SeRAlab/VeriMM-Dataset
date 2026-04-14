module pipeline_processor (  
    input clk,  
    input reset,  
    input [3:0] instruction,  
    output reg [15:0] result  
);  
    reg [15:0] reg_A, reg_B;  
    reg [15:0] mem_out;  
    reg [3:0] opcode;  
    reg [15:0] alu_result;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            reg_A <= 0;  
            reg_B <= 0;  
            result <= 0;  
        end else begin  
            // Instruction Fetch (IF)  
            opcode <= instruction;  
  
            // Instruction Decode (ID)  
            case (opcode)  
                4'b0001: reg_A <= 10;  // Add  
                4'b0010: reg_A <= 20;  // Subtract  
                4'b0011: reg_A <= 30;  // Multiply  
                4'b0100: reg_A <= 40;  // Divide  
                4'b0000: reg_A <= 0;   // NOP  
                default: reg_A <= 0;  
            endcase  
  
            // Execute (EX)  
            case (opcode)  
                4'b0001: alu_result <= reg_A + reg_B;  
                4'b0010: alu_result <= reg_A - reg_B;  
                4'b0011: alu_result <= reg_A * reg_B;  
                4'b0100: alu_result <= reg_A / reg_B;  
                4'b0000: alu_result <= 0;  
                default: alu_result <= 0;  
            endcase  
  
            // Memory Access (MEM) - Stub for memory operations  
            mem_out <= alu_result;  
          
            // Write Back (WB)  
            result <= mem_out;  
        end  
    end  
endmodule