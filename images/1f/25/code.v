module pipeline_processor(  
    input clk,  
    input reset,  
    input [7:0] instruction,  
    input [31:0] data_in,  
    output reg [31:0] result,  
    output reg valid  
);  
    // Define pipeline registers  
    reg [7:0] IF_ID_instr;  
    reg [31:0] ID_EX_data;  
    reg [31:0] EX_MEM_result;  
    reg [31:0] MEM_WB_result;  

    // Pipeline stages  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            // Reset all registers  
            IF_ID_instr <= 0;  
            ID_EX_data <= 0;  
            EX_MEM_result <= 0;  
            MEM_WB_result <= 0;  
            result <= 0;  
            valid <= 0;  
        end else begin  
            // Stage 1: Instruction Fetch  
            IF_ID_instr <= instruction;  

            // Stage 2: Instruction Decode  
            ID_EX_data <= data_in;  

            // Stage 3: Execute (simple addition operation)  
            EX_MEM_result <= ID_EX_data + IF_ID_instr;  

            // Stage 4: Memory Access (skipped for simplicity)  
            // Stage 5: Write Back  
            MEM_WB_result <= EX_MEM_result;  
            result <= MEM_WB_result;  
            valid <= 1;  
        end  
    end  
endmodule