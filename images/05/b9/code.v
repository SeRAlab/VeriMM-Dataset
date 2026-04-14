module pipeline_processor(input clk, input rst, input [4:0] in_data, output reg [4:0] out_data);  
    reg [4:0] stage1, stage2, stage3, stage4;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage1 <= 5'b0;  
            stage2 <= 5'b0;  
            stage3 <= 5'b0;  
            stage4 <= 5'b0;  
            out_data <= 5'b0;  
        end else begin  
            stage1 <= in_data;  
            stage2 <= stage1 + 1;  
            stage3 <= stage2 + 1;  
            stage4 <= stage3 + 1;  
            out_data <= stage4 + 1;  
        end  
    end  
endmodule