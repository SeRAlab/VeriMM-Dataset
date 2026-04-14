module top_module(led_clk,ledrst,ledwrite,ledaddrcs,ledwdata,ledout);input led_clk;
    input ledrst;
    input ledwrite; 
    input ledaddrcs; 
    input[15:0] ledwdata; 
    output[15:0] ledout; 
    
    reg [15:0] ledout;
    
    always @(posedge led_clk or posedge ledrst) begin
  
    end
endmodule