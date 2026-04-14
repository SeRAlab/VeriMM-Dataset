module pipeline_processor (  
    input clk,  
    input reset,  
    input [31:0] instruction_in,  
    output reg [31:0] result_out  
);  

    reg [31:0] IF_ID_instruction;  
    reg [31:0] ID_EX_instruction;  
    reg [31:0] EX_MEM_instruction;  
    reg [31:0] MEM_WB_instruction;  

    reg branch;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_ID_instruction <= 32'b0;  
            ID_EX_instruction <= 32'b0;  
            EX_MEM_instruction <= 32'b0;  
            MEM_WB_instruction <= 32'b0;  
            result_out <= 32'b0;  
        end else begin  
            // Instruction Fetch  
            IF_ID_instruction <= instruction_in;  
            
            // Instruction Decode  
            ID_EX_instruction <= IF_ID_instruction;  
            branch <= (ID_EX_instruction[31:26] == 6'b000011); // Example branch instruction  

            // Execute  
            if (branch) begin  
                // Flush the pipeline  
                EX_MEM_instruction <= 32'b0;  
            end else begin  
                EX_MEM_instruction <= ID_EX_instruction;  
            end  

            // Memory Access  
            MEM_WB_instruction <= EX_MEM_instruction;  

            // Write Back  
            result_out <= MEM_WB_instruction;  
        end  
    end  
endmodule