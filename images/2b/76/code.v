module pipelined_adder(input clk, input reset, input [7:0] a, input [7:0] b, output reg [7:0] sum);  
    reg [7:0] a_reg, b_reg;  
    reg [7:0] exec_result;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sum <= 0;  
            a_reg <= 0;  
            b_reg <= 0;  
            exec_result <= 0;  
        end else begin  
            // Stage 1: Fetch  
            a_reg <= a;  
            b_reg <= b;  
            
            // Stage 2: Decode (already done by simply holding values)  
            // Stage 3: Execute  
            exec_result <= a_reg + b_reg;  
            
            // Stage 4: Memory Access (not used in this simple adder)  
            // Stage 5: Write Back  
            sum <= exec_result;  
        end  
    end  
endmodule