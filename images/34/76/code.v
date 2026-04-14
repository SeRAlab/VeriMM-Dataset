module instruction_pipeline(clk, reset, instruction_in, instruction_out);  
    input clk, reset;  
    input [31:0] instruction_in;  
    output reg [31:0] instruction_out;  

    reg [31:0] IF_ID_reg;  
    reg [31:0] ID_EX_reg;  
    reg [31:0] EX_MEM_reg;  
    reg [31:0] MEM_WB_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_ID_reg <= 0;  
            ID_EX_reg <= 0;  
            EX_MEM_reg <= 0;  
            MEM_WB_reg <= 0;  
            instruction_out <= 0;  
        end else begin  
            // Pipeline logic  
            IF_ID_reg <= instruction_in;  
            ID_EX_reg <= IF_ID_reg;  
            EX_MEM_reg <= ID_EX_reg;  
            MEM_WB_reg <= EX_MEM_reg;  
            instruction_out <= MEM_WB_reg;  
        end  
    end  
endmodule