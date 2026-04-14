module top_module(clk,rst_n,req_compl_i,compl_done_i,cfg_to_turnoff,cfg_turnoff_ok);input clk; 
  input rst_n; 
  input req_compl_i; 
  input compl_done_i; 
  input cfg_to_turnoff; 
  output cfg_turnoff_ok; 
  reg trn_pending; 
  reg cfg_turnoff_ok; 
  always @ ( posedge clk or negedge rst_n ) begin 
  if (!rst_n ) begin 
  trn_pending <= 0; 
  end else begin 
  if (!trn_pending && req_compl_i) 
  trn_pending <= 1'b1; 
  else if (compl_done_i) 
  trn_pending <= 1'b0; 
  end 
  end 
  always @ ( posedge clk or negedge rst_n ) begin 
  if (!rst_n ) begin 
  cfg_turnoff_ok <= 1'b0; 
  end else begin 
  if ( cfg_to_turnoff && !trn_pending) 
  cfg_turnoff_ok <= 1'b1; 
  else 
  cfg_turnoff_ok <= 1'b0; 
  end 
  end 
 endmodule