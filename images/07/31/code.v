module divide_by_2 (  
    input wire clk,  
    input wire rst,  
    input wire in,  
    output reg out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            out <= 0;  
        else  
            out <= in;  
    end  
endmodule