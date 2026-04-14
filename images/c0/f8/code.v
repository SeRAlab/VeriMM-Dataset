module  omsp_sync_cell (
    data_out,                      
    clk,                           
    data_in,                       
    rst                            
);
output              data_out;      
input               clk;          
input               data_in;      
input               rst;          
reg  [1:0] data_sync;
always @(posedge clk or posedge rst)
  if (rst) data_sync <=  2'b00;
  else     data_sync <=  {data_sync[0], data_in};
assign     data_out   =   data_sync[1];
endmodule