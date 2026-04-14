module pipeline_processor(input clk,  
                          input rst,  
                          input [7:0] data_in,  
                          output reg [7:0] data_out);  
   
    reg [7:0] stage1_out, stage2_out, stage3_out;  
    reg [7:0] stage4_out, stage5_out, stage6_out;  
   
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage1_out <= 0;  
            stage2_out <= 0;  
            stage3_out <= 0;  
            stage4_out <= 0;  
            stage5_out <= 0;  
            stage6_out <= 0;  
            data_out <= 0;  
        end  
        else begin  
            stage1_out <= data_in + 1;  
            stage2_out <= stage1_out - 1;  
            stage3_out <= stage2_out * 2;  
            stage4_out <= stage3_out / 2;  
            stage5_out <= stage4_out % 5;  
            stage6_out <= stage5_out + 1;  
            data_out <= stage6_out - 1;  
        end  
    end  
endmodule