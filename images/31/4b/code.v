module instruction_pipeline(  
    input clk,  
    input rst,  
    input [7:0] instruction_in,  
    output reg [7:0] instruction_out,  
    output reg [7:0] decoded_instruction  
);  
    reg [7:0] instruction_IF;  
    reg [7:0] instruction_ID;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            instruction_IF <= 8'b0;  
            instruction_ID <= 8'b0;  
            decoded_instruction <= 8'b0;  
            instruction_out <= 8'b0;  
        end else begin  
            instruction_IF <= instruction_in;  
            instruction_ID <= instruction_IF;  
            decoded_instruction <= instruction_ID;  
            instruction_out <= instruction_ID;  
        end  
    end  
endmodule