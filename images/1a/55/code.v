module pipelined_adder(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] operand_a,  
    input wire [7:0] operand_b,  
    output reg [7:0] result  
);  
    reg [7:0] stage1_a, stage1_b;  
    reg [7:0] stage2_sum;  
    reg [6:0] stage_counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            stage1_a <= 0;  
            stage1_b <= 0;  
            stage2_sum <= 0;  
            result <= 0;  
            stage_counter <= 0;  
        end else begin  
            // Stage 1: Fetch operands  
            stage1_a <= operand_a;  
            stage1_b <= operand_b;  

            // Stage 2: Perform addition  
            stage2_sum <= stage1_a + stage1_b;  

            // Stage 7: Write back result  
            if (stage_counter == 6) begin  
                result <= stage2_sum;  
            end  
            stage_counter <= stage_counter + 1;  
        end  
    end  
endmodule