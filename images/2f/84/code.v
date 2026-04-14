module pipelined_processor(input clk,  
                           input reset,  
                           input [7:0] a,  
                           input [7:0] b,  
                           input [1:0] opcode,  
                           output reg [15:0] result);  

    reg [7:0] stage1_a, stage1_b;  
    reg [1:0] stage1_opcode;  
    reg [7:0] stage2_a, stage2_b;  
    reg [1:0] stage2_opcode;  
    reg [15:0] stage3_result;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            stage1_a <= 0;  
            stage1_b <= 0;  
            stage1_opcode <= 0;  
            stage2_a <= 0;  
            stage2_b <= 0;  
            stage2_opcode <= 0;  
            stage3_result <= 0;  
            result <= 0;  
        end else begin  
            // Stage 1: Instruction Fetch  
            stage1_a <= a;  
            stage1_b <= b;  
            stage1_opcode <= opcode;  

            // Stage 2: Instruction Decode  
            stage2_a <= stage1_a;  
            stage2_b <= stage1_b;  
            stage2_opcode <= stage1_opcode;  

            // Stage 3: Execution  
            case (stage2_opcode)  
                2'b00: stage3_result <= stage2_a + stage2_b; // ADD  
                2'b01: stage3_result <= stage2_a - stage2_b; // SUB  
                2'b10: stage3_result <= stage2_a * stage2_b; // MUL  
                2'b11: if (stage2_b != 0)  
                           stage3_result <= stage2_a / stage2_b; // DIV  
                       else  
                           stage3_result <= 16'hFFFF; // Handle division by zero  
            endcase  

            // Stage 4: Memory Access (not used in this simple example)  
            
            // Stage 5: Write Back  
            result <= stage3_result;  
        end  
    end  
endmodule