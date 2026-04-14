module pipeline_processor(  
    input clk,  
    input reset,  
    input [31:0] instruction_in,  
    output reg [31:0] result_out  
);  
    reg [31:0] IF_ID_instruction;  
    reg [31:0] ID_EX_instruction;  
    reg [31:0] EX_MEM_instruction;  
    reg [31:0] MEM_WB_instruction;  
    reg [31:0] registers [0:31]; // Register file  
    reg [31:0] ALU_result;  
    reg [31:0] memory_data;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            // Reset all registers  
            IF_ID_instruction <= 0;  
            ID_EX_instruction <= 0;  
            EX_MEM_instruction <= 0;  
            MEM_WB_instruction <= 0;  
            result_out <= 0;  
        end else begin  
            // Pipeline stages  
            IF_ID_instruction <= instruction_in; // IF Stage  
            ID_EX_instruction <= IF_ID_instruction; // ID Stage  
            EX_MEM_instruction <= ID_EX_instruction; // EX Stage  
            MEM_WB_instruction <= EX_MEM_instruction; // MEM Stage  
            result_out <= MEM_WB_instruction; // WB Stage  
        end  
    end  
endmodule