module fractional_n_pll (  
    input wire clk_ref,  
    input wire [15:0] fraction,  
    output reg clk_out  
);  
    reg [15:0] counter;  
    reg [15:0] vco;  
    parameter N = 16;  
    parameter M = 1;  
  
    always @(posedge clk_ref) begin  
        // Phase Detector Logic  
        counter <= counter + 1;  
        if (counter >= fraction) begin  
            clk_out <= ~clk_out;  
            counter <= 0;  
        end  
    end  
endmodule