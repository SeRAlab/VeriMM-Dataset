module top_module();parameter MSB = 1; 
  integer ii; 
  reg signed [2:0] ar_reg[0:MSB]; 
  wire signed [4:0] as_wr; 
  assign as_wr = {{2{ar_reg[0][2]}},ar_reg[1]}; 
  always @(as_wr) 
  for(ii=0; ii<(MSB+1); ii=ii+1) 
  begin 
  $display(" %t ar_reg=%0d w_assign=%0d", $time, ar_reg[ii], as_wr); 
  $display(" %t ar_reg[0]=3'b%3b ar_reg[1]=3'b%3b", $time, ar_reg[0], ar_reg[1]); 
  $display(" %t as_wr=5'b%5b", $time, as_wr); 
  end 
  initial 
  begin 
  $display("\n*** module %m **************************************"); 
  #10; 
  for(ii=0; ii<(MSB+1); ii=ii+1) 
  ar_reg[ii] <= 3'sd1; 
  #10; 
  for(ii=0; ii<(MSB+1); ii=ii+1) 
  ar_reg[ii] <= 3'sd0; 
  $display("\n\n"); 
  end 
 endmodule