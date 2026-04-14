module divide_by_2 (  
    input clk,  
    input rst,  
    input [3:0] in,  
    output reg [3:0] out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            out <= 4'b0000;  
        else  
            out <= in >> 1;  
    end  
endmodule