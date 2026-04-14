module pipeline_processor(clk, reset, instruction_in, instruction_out);  
    input clk, reset;  
    input [15:0] instruction_in;  
    output reg [15:0] instruction_out;  

    reg [15:0] IF_ID_reg, ID_EX_reg, EX_MEM_reg, MEM_WB_reg;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_ID_reg <= 16'b0;  
            ID_EX_reg <= 16'b0;  
            EX_MEM_reg <= 16'b0;  
            MEM_WB_reg <= 16'b0;  
            instruction_out <= 16'b0;  
        end else begin  
            // Pipeline Stages  
            IF_ID_reg <= instruction_in;          // Fetch  
            ID_EX_reg <= IF_ID_reg;                // Decode  
            EX_MEM_reg <= ID_EX_reg;               // Execute  
            MEM_WB_reg <= EX_MEM_reg;              // Memory Access  
            instruction_out <= MEM_WB_reg;         // Write Back  
        end  
    end  
endmodule