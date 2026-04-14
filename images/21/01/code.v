module pipelined_processor (  
    input clk,  
    input reset,  
    input [7:0] data_a,  
    input [7:0] data_b,  
    input operation, // 0 for add, 1 for subtract  
    output reg [7:0] result  
);  
    reg [7:0] stage1_a, stage1_b;  
    reg stage1_op;  
    reg [7:0] stage2_a, stage2_b;  
    reg stage2_op;  
    reg [7:0] stage3_result;  
    reg [7:0] stage4_result;  
    reg [7:0] stage5_result;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            stage1_a <= 0;  
            stage1_b <= 0;  
            stage1_op <= 0;  
            stage2_a <= 0;  
            stage2_b <= 0;  
            stage2_op <= 0;  
            stage3_result <= 0;  
            stage4_result <= 0;  
            stage5_result <= 0;  
            result <= 0;  
        end else begin  
            // Stage 1: Fetch  
            stage1_a <= data_a;  
            stage1_b <= data_b;  
            stage1_op <= operation;  

            // Stage 2: Decode  
            stage2_a <= stage1_a;  
            stage2_b <= stage1_b;  
            stage2_op <= stage1_op;  

            // Stage 3: Execute  
            if (stage2_op)  
                stage3_result <= stage2_a - stage2_b;  
            else  
                stage3_result <= stage2_a + stage2_b;  

            // Stage 4: Memory (no operation in this case)  
            stage4_result <= stage3_result;  

            // Stage 5: Write Back  
            stage5_result <= stage4_result;  
            result <= stage5_result;  
        end  
    end  
endmodule