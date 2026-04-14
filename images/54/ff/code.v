module top_module(
    i_clk,
    i_rst,
    i_signalReal,
    i_signalImag,
    o_mag
    );input                i_clk;
    input                i_rst;   
    input  signed [15:0] i_signalReal; 
    input  signed [15:0] i_signalImag; 
    output signed [15:0] o_mag;        
    
    wire   signed [31:0] realTemp;     
    wire   signed [31:0] imagTemp;     
    wire   signed [15:0] magTemp;      
    reg    signed [15:0] magFinal;     
    
    assign realTemp = (i_signalReal*i_signalReal);
    assign imagTemp = (i_signalImag*i_signalImag);
    assign magTemp = realTemp[31:16] + imagTemp[31:16];
    
    
        
    always @(posedge i_clk)
      begin
      if(i_rst)
          begin
              magFinal <= 16'h0;
          end
      else
          begin
              magFinal <= magTemp[15:0];
          end
      end
    
    assign o_mag = magFinal;
endmodule