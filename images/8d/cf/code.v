module top_module(nrst, clk, wr_req, rd_req, wr_sta, rd_sta);input nrst; 
  input clk; 
  input wr_req; 
  input rd_req; 
  output wr_sta; 
  output rd_sta; 
  reg wr_sta; 
  reg rd_pend; 
  always @(posedge clk or negedge nrst) begin 
  if (~nrst) begin 
  wr_sta <= 1'b0; 
  end else begin 
  wr_sta <= wr_req; 
  end 
  end 
  always @(posedge clk or negedge nrst) begin 
  if (~nrst) begin 
  rd_pend <= 1'b0; 
  end else if (rd_req) begin 
  rd_pend <= 1'b1; 
  end else if (rd_sta) begin 
  rd_pend <= 1'b0; 
  end 
  end 
  assign rd_sta = rd_pend & ~wr_sta; 
 endmodule