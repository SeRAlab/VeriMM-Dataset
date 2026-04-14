module pipeline_cpu (
    input clk,
    input rst,
    input [15:0] instruction_in,
    output reg [15:0] result_out
);
    reg [15:0] fetch_reg;
    reg [15:0] decode_reg;
    reg [15:0] execute_reg;
    reg [15:0] memory_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fetch_reg <= 16'b0;
            decode_reg <= 16'b0;
            execute_reg <= 16'b0;
            memory_reg <= 16'b0;
            result_out <= 16'b0;
        end else begin
            // Pipeline Stages
            fetch_reg <= instruction_in; // Fetch stage
            decode_reg <= fetch_reg;      // Decode stage
            execute_reg <= decode_reg;    // Execute stage
            memory_reg <= execute_reg;     // Memory Access stage
            
            // Simple ALU operation (for example, add a constant)
            result_out <= memory_reg + 16'd5; // Write Back stage
        end
    end
endmodule