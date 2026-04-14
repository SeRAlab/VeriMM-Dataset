module pll_2x (  
    input clk_in,  
    input reset,  
    output reg clk_out  
);  
    reg [1:0] phase;  
    reg vco_clk;  

    always @(posedge clk_in or posedge reset) begin  
        if (reset) begin  
            phase <= 2'b00;  
            vco_clk <= 0;  
        end else begin  
            phase <= phase + 1;  
            if (phase == 2'b00) begin  
                vco_clk <= ~vco_clk;  
            end  
        end  
    end  

    always @(posedge vco_clk) begin  
        clk_out <= ~clk_out;  
    end  
endmodule