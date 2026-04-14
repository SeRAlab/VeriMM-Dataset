module instruction_pipeline (  
    input clk,  
    input reset,  
    input [31:0] instruction_in,  
    output reg [31:0] final_result  
);  
    reg [31:0] IF_ID_instruction;  
    reg [31:0] ID_EX_instruction;  
    reg [31:0] EX_MEM_instruction;  
    reg [31:0] MEM_WB_instruction;  
    reg [31:0] result_from_memory;  
    reg [31:0] ALU_result;  

    // Stages of the pipeline  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_ID_instruction <= 32'b0;  
            ID_EX_instruction <= 32'b0;  
            EX_MEM_instruction <= 32'b0;  
            MEM_WB_instruction <= 32'b0;  
            final_result <= 32'b0;  
        end else begin  
            // Instruction Fetch Stage  
            IF_ID_instruction <= instruction_in;  
            // Instruction Decode Stage  
            ID_EX_instruction <= IF_ID_instruction;  
            // Execute Stage  
            ALU_result <= ID_EX_instruction + 1; // Simple operation  
            EX_MEM_instruction <= ALU_result;  
            // Memory Access Stage  
            result_from_memory <= EX_MEM_instruction; // Simulated memory access  
            MEM_WB_instruction <= result_from_memory;  
            // Write Back Stage  
            final_result <= MEM_WB_instruction;  
        end  
    end  
endmodule