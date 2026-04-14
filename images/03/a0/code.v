module divide_by_2(  
    input clk,  
    input rst,  
    input in,  
    output reg out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            out <= 1'b0;  
        else  
            out <= in;  
    end  
endmodule