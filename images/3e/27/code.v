module pipeline_processor (  
    input clk,  
    input rst,  
    input [31:0] data_in,  
    input [1:0] control, // 00: ADD, 01: SUB  
    output reg [31:0] data_out  
);  
    reg [31:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;  
    reg [1:0] ctrl_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage1 <= 0;  
            stage2 <= 0;  
            stage3 <= 0;  
            stage4 <= 0;  
            stage5 <= 0;  
            stage6 <= 0;  
            stage7 <= 0;  
            data_out <= 0;  
        end else begin  
            // Stage 1: Fetch  
            stage1 <= data_in;  
            // Stage 2: Decode  
            stage2 <= stage1;  
            ctrl_reg <= control;  
            // Stage 3: Execute  
            stage3 <= (ctrl_reg == 2'b00) ? stage2 + 32'h1 : stage2 - 32'h1;  
            // Stage 4: Memory Access  
            stage4 <= stage3;  
            // Stage 5: Write Back  
            stage5 <= stage4;  
            // Stage 6: Additional Processing  
            stage6 <= stage5;  
            // Stage 7: Final Output  
            stage7 <= stage6;  
            data_out <= stage7;  
        end  
    end  
endmodule