module pipeline_processor (  
    input clk,  
    input rst,  
    input [7:0] A,  
    input [7:0] B,  
    output reg [7:0] Result  
);  
    reg [7:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;  

    always @(posedge clk or negedge rst) begin  
        if (!rst) begin  
            stage1 <= 8'b0;  
            stage2 <= 8'b0;  
            stage3 <= 8'b0;  
            stage4 <= 8'b0;  
            stage5 <= 8'b0;  
            stage6 <= 8'b0;  
            stage7 <= 8'b0;  
            Result <= 8'b0;  
        end  
        else begin  
            stage1 <= A;  
            stage2 <= stage1;  
            stage3 <= stage2;  
            stage4 <= stage3;  
            stage5 <= stage4;  
            stage6 <= stage5;  
            stage7 <= stage6 + B;  
            Result <= stage7;  
        end  
    end  
endmodule