module divide_by_4(  
    input clk,  
    input rst,  
    output reg [1:0] out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            out <= 2'b00;  
        else  
            out <= out + 1;  
    end  
endmodule