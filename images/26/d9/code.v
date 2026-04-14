module fft_4point (  
    input clk,  
    input rst,  
    input [15:0] x0,  
    input [15:0] x1,  
    input [15:0] x2,  
    input [15:0] x3,  
    output reg [15:0] y0,  
    output reg [15:0] y1,  
    output reg [15:0] y2,  
    output reg [15:0] y3  
);  
  
    reg [15:0] stage1_out1, stage1_out2, stage1_out3, stage1_out4;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y0 <= 0;  
            y1 <= 0;  
            y2 <= 0;  
            y3 <= 0;  
        end else begin  
            // Stage 1  
            stage1_out1 <= x0 + x1;  
            stage1_out2 <= x0 - x1;  
            stage1_out3 <= x2 + x3;  
            stage1_out4 <= x2 - x3;  
            // Stage 2  
            y0 <= stage1_out1 + stage1_out3;  
            y1 <= stage1_out2 + (stage1_out4 >>> 1);  
            y2 <= stage1_out1 - stage1_out3;  
            y3 <= stage1_out2 - (stage1_out4 >>> 1);  
        end  
    end  
endmodule