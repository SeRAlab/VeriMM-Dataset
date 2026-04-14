module frequency_divider (  
    input clk,  
    input reset,  
    output reg divided_clk  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            divided_clk <= 0;  
        else  
            divided_clk <= ~divided_clk;  
    end  
endmodule