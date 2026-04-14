module pll_8x(clk_in, enable, clk_out);  
    input clk_in;  
    input enable;  
    output reg clk_out;  

    reg [2:0] counter;  

    always @(posedge clk_in) begin  
        if (enable) begin  
            counter <= counter + 1;  
            if (counter == 3'd7) begin  
                clk_out <= ~clk_out;  
                counter <= 3'd0;  
            end  
        end  
    end  
endmodule