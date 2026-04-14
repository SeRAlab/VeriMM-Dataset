module pipeline_risc (  
    input clk,  
    input rst,  
    input [31:0] instruction,  
    output reg [31:0] result  
);  
    reg [31:0] IF_ID_instr;  
    reg [31:0] ID_EX_instr;  
    reg [31:0] EX_MEM_result;  
    reg [31:0] MEM_WB_result;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            IF_ID_instr <= 32'b0;  
            ID_EX_instr <= 32'b0;  
            EX_MEM_result <= 32'b0;  
            MEM_WB_result <= 32'b0;  
            result <= 32'b0;  
        end else begin  
            // Pipeline stages  
            IF_ID_instr <= instruction;  
            ID_EX_instr <= IF_ID_instr;  
            EX_MEM_result <= ID_EX_instr + 32'd1; // Simple execution logic  
            MEM_WB_result <= EX_MEM_result;  
            result <= MEM_WB_result;  
        end  
    end  
endmodule