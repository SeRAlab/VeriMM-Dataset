module register_16bit (dout, din, clk, reset, en);
   input [15:0] din;
   input clk, reset, en;
   output [15:0] dout;
   
   reg [15:0] dout;
   
   always @(posedge clk or posedge reset) begin
      if (reset) 
         dout <= 16'b0;
      else if (en)
         dout <= din;
   end
   
endmodule