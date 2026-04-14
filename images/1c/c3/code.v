module pll_2x (  
    input wire clk_in,  
    input wire reset,  
    input wire enable,  
    output reg clk_out  
);  

    reg [1:0] state;  

    always @(posedge clk_in or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00;  
            clk_out <= 0;  
        end else if (enable) begin  
            state <= state + 1;  
            if (state == 2'b01) begin  
                clk_out <= ~clk_out;  
            end  
        end  
    end  
endmodule