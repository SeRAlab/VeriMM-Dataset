module pipeline_processor (  
    input clk,  
    input [15:0] data_in,  
    input [1:0] op_code, // 00: ADD, 01: SUB, 10: MUL, 11: DIV  
    output reg [15:0] result  
);  
    reg [15:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;  

    always @(posedge clk) begin  
        stage1 <= data_in;  
        stage2 <= stage1;  
        stage3 <= stage2;  
        stage4 <= stage3;  
        stage5 <= stage4;  
        stage6 <= stage5;  
        
        case (op_code)  
            2'b00: stage7 <= stage6 + stage6;    // ADD  
            2'b01: stage7 <= stage6 - stage6;    // SUB  
            2'b10: stage7 <= stage6 * stage6;    // MUL  
            2'b11: stage7 <= stage6 / (stage6 != 0 ? stage6 : 1); // DIV  
            default: stage7 <= 16'b0;  
        endcase  
    end  

    always @(posedge clk) begin  
        result <= stage7;  
    end  
endmodule