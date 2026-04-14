module pipeline_2stage (  
    input clk,  
    input rst,  
    input [3:0] in_data,  
    output reg [4:0] out_data  
);  

    reg [4:0] stage1;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage1 <= 5'b0;  
            out_data <= 5'b0;  
        end else begin  
            stage1 <= in_data + 1;  
            out_data <= stage1 * 2;  
        end  
    end  
endmodule