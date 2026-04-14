module frequency_divider (  
    input clk,  
    input reset,  
    output reg clk_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            clk_out <= 0;  
        else  
            clk_out <= ~clk_out;  
    end  
endmodule