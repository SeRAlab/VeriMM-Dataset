module top_module(input de_clk,input rstn,input tog_in,output sig_out);reg c0_rdya; 
  reg c0_rdyc; 
  always @(posedge de_clk or negedge rstn) begin 
  if(!rstn) c0_rdya <= 1'b0; 
  else c0_rdya <= tog_in; 
  end 
  always @(posedge de_clk or negedge rstn) begin 
  if(!rstn) c0_rdyc <= 1'b0; 
  else c0_rdyc <= c0_rdya; 
  end 
  assign sig_out = c0_rdyc ^ c0_rdya; 
 endmodule