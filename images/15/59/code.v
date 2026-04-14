module pipelined_processor (  
    input clk,  
    input rst,  
    input [2:0] opcode,  
    input [31:0] data_in1,  
    input [31:0] data_in2,  
    output reg [31:0] result  
);  
    reg [31:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;  
    reg [31:0] final_result;  
   
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage1 <= 0;  
            stage2 <= 0;  
            stage3 <= 0;  
            stage4 <= 0;  
            stage5 <= 0;  
            stage6 <= 0;  
            stage7 <= 0;  
            result <= 0;  
        end else begin  
            // Stage 1: Input data  
            stage1 <= {data_in1, data_in2};  
            // Stage 2: Select operation  
            case (opcode)  
                3'b000: stage2 <= stage1[31:0] + stage1[63:32]; // Addition  
                3'b001: stage2 <= stage1[31:0] - stage1[63:32]; // Subtraction  
                3'b010: stage2 <= stage1[31:0] * stage1[63:32]; // Multiplication  
                3'b011: stage2 <= stage1[31:0] / stage1[63:32]; // Division  
                default: stage2 <= 0;  
            endcase  
            // Stage 3: Pass through  
            stage3 <= stage2;  
            // Stage 4: Pass through  
            stage4 <= stage3;  
            // Stage 5: Pass through  
            stage5 <= stage4;  
            // Stage 6: Pass through  
            stage6 <= stage5;  
            // Stage 7: Store result  
            stage7 <= stage6;  
            final_result <= stage7;  
            result <= final_result;  
        end  
    end  
endmodule