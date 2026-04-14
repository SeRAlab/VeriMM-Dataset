module pll_2x (  
    input wire clk_in,  
    input wire reset,  
    output reg clk_out  
);  
    always @(posedge clk_in or posedge reset) begin  
        if (reset) begin  
            clk_out <= 0;  
        end else begin  
            clk_out <= ~clk_out;  
        end  
    end  
endmodule