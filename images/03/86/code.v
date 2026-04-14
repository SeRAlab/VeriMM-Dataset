module pipeline_register(  
    input clk,  
    input rst,  
    input [7:0] in,  
    output reg [7:0] out  
);  
    reg [7:0] stage1;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage1 <= 8'b0;  
            out <= 8'b0;  
        end else begin  
            stage1 <= in;  
            out <= stage1;  
        end  
    end  
endmodule