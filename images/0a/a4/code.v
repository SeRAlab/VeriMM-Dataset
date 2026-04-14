module pipeline_processor(  
    input clk,  
    input [7:0] A,  
    input [7:0] B,  
    input [2:0] opcode,  
    output reg [7:0] result  
);  
    reg [7:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;  
    reg [2:0] stage_opcode;  

    always @(posedge clk) begin  
        stage1 <= A;  
        stage2 <= B;  
        stage3 <= stage1;  
        stage4 <= stage2;  
        stage5 <= stage3;  
        stage6 <= stage4;  
        stage7 <= stage5;  
        stage_opcode <= opcode;  
    end  

    always @(posedge clk) begin  
        case(stage_opcode)  
            3'b000: result <= stage7 + stage6; // ADD  
            3'b001: result <= stage7 - stage6; // SUB  
            3'b010: result <= stage7 & stage6; // AND  
            3'b011: result <= stage7 | stage6; // OR  
            3'b100: result <= stage7 ^ stage6; // XOR  
            default: result <= 8'b00000000;  
        endcase  
    end  
endmodule