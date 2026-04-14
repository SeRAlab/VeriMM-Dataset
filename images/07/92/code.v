module pipeline_processor (  
    input clk,  
    input reset,  
    input [7:0] instruction,  
    output reg [7:0] result  
);  

    reg [7:0] IF_ID_instr;  
    reg [7:0] ID_EX_instr;  
    reg [7:0] EX_MEM_instr;  
    reg [7:0] MEM_WB_instr;  
    reg [7:0] reg_file; // single register  
    reg [7:0] mem [0:255]; // memory array  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_ID_instr <= 0;  
            ID_EX_instr <= 0;  
            EX_MEM_instr <= 0;  
            MEM_WB_instr <= 0;  
            result <= 0;  
        end else begin  
            // Stage 1: Instruction Fetch  
            IF_ID_instr <= instruction;  

            // Stage 2: Instruction Decode  
            ID_EX_instr <= IF_ID_instr;  

            // Stage 3: Execute  
            // Simple execution: assume instruction is an immediate value to add to register  
            EX_MEM_instr <= ID_EX_instr + reg_file;  

            // Stage 4: Memory Access  
            // No memory operation in this simple example  
            MEM_WB_instr <= EX_MEM_instr;  

            // Stage 5: Write Back  
            reg_file <= MEM_WB_instr;  
            result <= reg_file;  
        end  
    end  
endmodule