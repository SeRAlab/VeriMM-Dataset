module frequency_divider (  
    input clk_in,  
    input rst,  
    output reg clk_out  
);  
    always @(posedge clk_in or posedge rst) begin  
        if (rst)  
            clk_out <= 0;  
        else  
            clk_out <= ~clk_out;  
    end  
endmodule