module PLL_4x (  
    input wire clk_in,  
    input wire reset,  
    input wire enable,  
    output reg clk_out  
);  
    reg [1:0] count;  
    always @(posedge clk_in or posedge reset) begin  
        if (reset) begin  
            clk_out <= 0;  
            count <= 0;  
        end else if (enable) begin  
            if (count == 3) begin  
                clk_out <= ~clk_out;  
                count <= 0;  
            end else begin  
                count <= count + 1;  
            end  
        end  
    end  
endmodule