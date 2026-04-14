module divide_by_2 (  
    input clk,  
    input reset,  
    input in,  
    output reg out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            out <= 0;  
        else  
            out <= in;  
    end  
endmodule