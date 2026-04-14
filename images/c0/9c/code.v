module  omsp_sync_reset (
    rst_s,                        
    clk,                          
    rst_a                         
);
output              rst_s;        
input               clk;          
input               rst_a;        
reg    [1:0] data_sync;
always @(posedge clk or posedge rst_a)
  if (rst_a) data_sync <=  2'b11;
  else       data_sync <=  {data_sync[0], 1'b0};
assign       rst_s      =   data_sync[1];
endmodule