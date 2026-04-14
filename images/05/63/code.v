module pipeline_processor(  
    input clk,  
    input rst,  
    input [4:0] instruction,  
    output reg [4:0] out_instruction  
);  

    reg [4:0] IF_ID;  
    reg [4:0] ID_EX;  
    reg [4:0] EX_MEM;  
    reg [4:0] MEM_WB;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            IF_ID <= 5'b0;  
            ID_EX <= 5'b0;  
            EX_MEM <= 5'b0;  
            MEM_WB <= 5'b0;  
            out_instruction <= 5'b0;  
        end else begin  
            IF_ID <= instruction;  
            ID_EX <= IF_ID;  
            EX_MEM <= ID_EX;  
            MEM_WB <= EX_MEM;  
            out_instruction <= MEM_WB;  
        end  
    end  
endmodule