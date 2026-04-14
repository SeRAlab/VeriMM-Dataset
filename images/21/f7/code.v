module divide_by_2 (  
    input clk,  
    input rst,  
    input din,  
    output reg dout  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            dout <= 1'b0;  
        else  
            dout <= din;  
    end  
endmodule