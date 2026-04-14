module divide_by_8 (  
    input [2:0] in,  
    output reg out,  
    input clk,  
    input rst  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            out <= 0;  
        else  
            out <= (in == 3'b000) ? 1 : 0;  
    end  
endmodule