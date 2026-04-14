module divide_by_4 (  
    input clk,  
    input rst,  
    input [1:0] in_num,  
    output reg [1:0] quotient  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 2'b00;  
        end else begin  
            quotient <= in_num / 4;  
        end  
    end  
endmodule