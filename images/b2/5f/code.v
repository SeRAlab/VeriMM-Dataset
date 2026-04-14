module top_module(dout0,rstn, clk, dval0, dbgsel);input rstn; 
  input clk; 
  input [7:0] dval0; 
  input [7:0] dbgsel; 
  output reg [7:0] dout0; 
  reg [7:0] dbgsel_d1r; 
  always_comb begin 
  if (((dbgsel_d1r >= 34) && (dbgsel_d1r < 65))) begin 
  dout0 = dval0; 
  end 
  else begin 
  dout0 = 0; 
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