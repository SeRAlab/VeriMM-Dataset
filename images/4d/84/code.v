module top_module(dout1,rstn, clk, dval1, dbgsel);input rstn; 
  input clk; 
  input [7:0] dval1; 
  input [7:0] dbgsel; 
  output reg [7:0] dout1; 
  reg [7:0] dbgsel_d1r; 
  always_comb begin 
  if (((dbgsel_d1r >= 84) && (dbgsel_d1r < 95))) begin 
  dout1 = dval1; 
  end 
  else begin 
  dout1 = 0; 
  end 
  end 
  always @(posedge clk) begin 
  if ((rstn == 0)) begin 
  dbgsel_d1r <= 0; 
  end 
  else begin 
  dbgsel_d1r <= dbgsel; 
  end 
  end 
 endmodule