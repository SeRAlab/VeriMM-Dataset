module pipeline_processor(  
    input clk,  
    input rst,  
    input [4:0] instruction_in,  
    output reg [4:0] instruction_out  
);  
    reg [4:0] IF_ID, ID_EX, EX_MEM, MEM_WB;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            IF_ID <= 5'b00000;  
            ID_EX <= 5'b00000;  
            EX_MEM <= 5'b00000;  
            MEM_WB <= 5'b00000;  
            instruction_out <= 5'b00000;  
        end else begin  
            IF_ID <= instruction_in;  
            ID_EX <= IF_ID;  
            EX_MEM <= ID_EX;  
            MEM_WB <= EX_MEM;  
            instruction_out <= MEM_WB;  
        end  
    end  
endmodule