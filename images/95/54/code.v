module top_module(clk, resetb, start, done, ain, bin, yout);parameter N = 16; 
 input clk; 
 input resetb; 
 input start; 
 input [15:0] ain; 
 input [15:0] bin; 
 output [31:0] yout; 
 output done; 
 reg [31:0] a; 
 reg [15:0] b; 
 reg [31:0] yout; 
 reg done; 
 always @(posedge clk or negedge resetb) begin 
  if (~resetb) begin 
  a <= 0; 
  b <= 0; 
  yout <= 0; 
  done <= 1'b1; 
  end 
  else begin 
  if (start) begin 
  a <= ain; 
  b <= bin; 
  yout <= 0; 
  done <= 0; 
  end 
  else begin 
  if (~done) begin 
  if (b != 0) begin 
  if (b[0]) begin 
  yout <= yout + a; 
  end 
  b <= b >> 1; 
  a <= a << 1; 
  $display ("a = %h, b = %h, yout = %h", a,b,yout); 
  end 
  else begin 
  done <= 1'b1; 
  end 
  end 
  end 
  end 
 end 
 endmodule