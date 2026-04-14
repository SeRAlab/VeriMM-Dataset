module instruction_pipeline(input clk, input reset, input [31:0] instruction_in,  
                            output reg [31:0] instruction_out,  
                            output reg [31:0] reg_data_out);  
  
    reg [31:0] IF_reg, ID_reg, EX_reg, MEM_reg;  
    reg [31:0] reg_data[0:31]; // Simple register file  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_reg <= 0;  
            ID_reg <= 0;  
            EX_reg <= 0;  
            MEM_reg <= 0;  
            instruction_out <= 0;  
            reg_data_out <= 0;  
        end else begin  
            // Instruction Fetch Stage  
            IF_reg <= instruction_in;  
            // Instruction Decode Stage  
            ID_reg <= IF_reg;  
            // Execute Stage (simple forwarding)  
            EX_reg <= ID_reg;  
            // Memory Stage  
            MEM_reg <= EX_reg;  
            // Write Back Stage  
            instruction_out <= MEM_reg;  
            reg_data_out <= reg_data[MEM_reg[4:0]]; // Assume reg_data[4:0] is the destination register  
        end  
    end  
endmodule