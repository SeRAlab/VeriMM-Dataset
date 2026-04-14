module divide_by_2(  
    input clk,  
    input reset,  
    input din,  
    output reg dout  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            dout <= 1'b0;  
        else  
            dout <= din;  
    end  
endmodule