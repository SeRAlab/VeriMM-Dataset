module instruction_pipeline(  
    input clk,  
    input reset,  
    input [31:0] instruction,  
    output reg [31:0] result  
);  
    reg [31:0] pc;  
    reg [31:0] instruction_reg;  
    reg [31:0] alu_result;  
    reg [31:0] mem_data;  
    reg [4:0] write_reg;  
    
    initial begin  
        pc = 0;  
        instruction_reg = 0;  
        alu_result = 0;  
        mem_data = 0;  
        write_reg = 0;  
    end  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            pc <= 0;  
            instruction_reg <= 0;  
            alu_result <= 0;  
            mem_data <= 0;  
            write_reg <= 0;  
        end else begin  
            // Instruction Fetch  
            instruction_reg <= instruction;  
            // Assume a simple ALU operation here  
            alu_result <= instruction_reg + 1;  
            // Memory Access (mock)  
            mem_data <= alu_result;  
            // Write Back  
            result <= mem_data;  
        end  
    end  
endmodule