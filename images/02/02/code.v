module pipeline_incrementer (  
    input clk,  
    input reset,  
    input [4:0] in_value,  
    output reg [4:0] out_value  
);  
    reg [4:0] fetch_reg, decode_reg, execute_reg, memory_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            fetch_reg <= 5'b0;  
            decode_reg <= 5'b0;  
            execute_reg <= 5'b0;  
            memory_reg <= 5'b0;  
            out_value <= 5'b0;  
        end else begin  
            fetch_reg <= in_value;  
            decode_reg <= fetch_reg + 1;  
            execute_reg <= decode_reg + 1;  
            memory_reg <= execute_reg + 1;  
            out_value <= memory_reg + 1;  
        end  
    end  
endmodule