module pipelined_processor (  
    input clk,  
    input reset,  
    input [31:0] instruction_in,  
    output reg [31:0] result_out  
);  
    reg [31:0] IF_ID, ID_EX, EX_MEM, MEM_WB;  
    reg [31:0] PC;  
    reg [31:0] ALU_result;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            PC <= 0;  
            IF_ID <= 0;  
            ID_EX <= 0;  
            EX_MEM <= 0;  
            MEM_WB <= 0;  
            result_out <= 0;  
        end else begin  
            // Fetch stage  
            IF_ID <= instruction_in;  
            
            // Decode stage  
            ID_EX <= IF_ID;  
            
            // Execute stage  
            ALU_result <= ID_EX + 1; // Simple addition for demo  
            EX_MEM <= ALU_result;  
            
            // Memory stage  
            MEM_WB <= EX_MEM;  
            
            // Write-back stage  
            result_out <= MEM_WB;  
        end  
    end  
endmodule