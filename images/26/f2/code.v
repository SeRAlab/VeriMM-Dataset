module pll (  
    input wire clk_ref,  
    input wire reset,  
    output reg clk_out  
);  
    reg [1:0] phase;  
    reg vco;  
    always @(posedge clk_ref or posedge reset) begin  
        if (reset) begin  
            phase <= 2'b00;  
            vco <= 1'b0;  
            clk_out <= 1'b0;  
        end else begin  
            // Simple phase detection logic  
            phase <= phase + 1;  
            vco <= ~vco; // Toggle VCO output  
            clk_out <= vco; // Output clock follows VCO  
        end  
    end  
endmodule