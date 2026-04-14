module pipeline_processor (  
    input clk,  
    input rst,  
    input [3:0] in_data,  
    output reg [3:0] out_data  
);  
    reg [3:0] stage1;  
    reg [3:0] stage2;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage1 <= 4'b0000;  
            stage2 <= 4'b0000;  
            out_data <= 4'b0000;  
        end else begin  
            stage1 <= in_data + 4'b0001;  
            stage2 <= stage1 & 4'b1010;  
            out_data <= stage2;  
        end  
    end  
endmodule