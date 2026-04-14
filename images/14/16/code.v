module pipelined_processor(  
    input clk,  
    input rst,  
    input [15:0] instruction,  
    output reg [31:0] result  
);  
    reg [15:0] IF_ID_instr;  
    reg [15:0] ID_EX_instr;  
    reg [31:0] EX_MEM_result;  
    reg [31:0] WB_result;  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            IF_ID_instr <= 16'b0;  
            ID_EX_instr <= 16'b0;  
            EX_MEM_result <= 32'b0;  
            result <= 32'b0;  
        end else begin  
            // Stage 1: Instruction Fetch  
            IF_ID_instr <= instruction;  
            // Stage 2: Instruction Decode  
            ID_EX_instr <= IF_ID_instr;  
            // Stage 3: Execute  
            case(ID_EX_instr[15:12])  
                4'b0000: EX_MEM_result <= ID_EX_instr[11:0] + ID_EX_instr[11:0]; // ADD  
                4'b0001: EX_MEM_result <= ID_EX_instr[11:0] - ID_EX_instr[11:0]; // SUB  
                4'b0010: EX_MEM_result <= ID_EX_instr[11:0] * ID_EX_instr[11:0]; // MUL  
                4'b0011: EX_MEM_result <= ID_EX_instr[11:0] / ID_EX_instr[11:0]; // DIV  
                default: EX_MEM_result <= 32'b0;  
            endcase  
            // Stage 4: Memory Access  
            // (No memory access in this simple model)  
            // Stage 5: Write Back  
            WB_result <= EX_MEM_result;  
            result <= WB_result;  
        end  
    end  
endmodule