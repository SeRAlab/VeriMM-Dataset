module divide_by_4(  
    input clk,  
    input rst,  
    input [3:0] in_data,  
    output reg [3:0] out_data  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out_data <= 4'b0000;  
        end else begin  
            out_data <= in_data / 4;  
        end  
    end  
endmodule