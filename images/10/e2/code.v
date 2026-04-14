module instruction_pipeline(  
    input clk,  
    input reset,  
    input [4:0] instruction_in,  
    output reg [4:0] instruction_out  
);  
    reg [4:0] IF_reg;  
    reg [4:0] ID_reg;  
    reg [4:0] EX_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_reg <= 5'b00000;  
            ID_reg <= 5'b00000;  
            EX_reg <= 5'b00000;  
            instruction_out <= 5'b00000;  
        end  
        else begin  
            IF_reg <= instruction_in;  
            ID_reg <= IF_reg;  
            EX_reg <= ID_reg;  
            instruction_out <= EX_reg;  
        end  
    end  
endmodule