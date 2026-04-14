module divide_by_2 (  
    input wire clk,  
    input wire reset,  
    input wire in,  
    output reg out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            out <= 1'b0;  
        else  
            out <= in ^ out;  
    end  
endmodule