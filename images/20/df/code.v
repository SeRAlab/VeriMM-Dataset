module instruction_pipeline (  
    input clk,  
    input rst,  
    input [31:0] new_instruction,  
    output reg [31:0] instruction_IF,  
    output reg [31:0] instruction_ID,  
    output reg [31:0] instruction_EX,  
    output reg [31:0] instruction_WB  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            instruction_IF <= 32'b0;  
            instruction_ID <= 32'b0;  
            instruction_EX <= 32'b0;  
            instruction_WB <= 32'b0;  
        end else begin  
            instruction_WB <= instruction_EX;  
            instruction_EX <= instruction_ID;  
            instruction_ID <= instruction_IF;  
            instruction_IF <= new_instruction;  
        end  
    end  
endmodule