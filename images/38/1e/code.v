module instruction_pipeline (  
    input clk,  
    input rst,  
    input [31:0] instruction_in,  
    output reg [31:0] instruction_out  
);  
    reg [31:0] fetch_reg;  
    reg [31:0] decode_reg;  
    reg [31:0] execute_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            fetch_reg <= 32'b0;  
            decode_reg <= 32'b0;  
            execute_reg <= 32'b0;  
            instruction_out <= 32'b0;  
        end else begin  
            fetch_reg <= instruction_in;  
            decode_reg <= fetch_reg;  
            execute_reg <= decode_reg;  
            instruction_out <= execute_reg;  
        end  
    end  
endmodule