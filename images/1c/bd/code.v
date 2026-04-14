module instruction_pipeline (  
    input clk,  
    input rst,  
    input [31:0] instruction_in,  
    output reg [31:0] instruction_out  
);  

    reg [31:0] IF_reg;  
    reg [31:0] ID_reg;  
    reg [31:0] EX_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            IF_reg <= 32'b0;  
            ID_reg <= 32'b0;  
            EX_reg <= 32'b0;  
            instruction_out <= 32'b0;  
        end else begin  
            IF_reg <= instruction_in;  
            ID_reg <= IF_reg;  
            EX_reg <= ID_reg;  
            instruction_out <= EX_reg;  
        end  
    end  
endmodule