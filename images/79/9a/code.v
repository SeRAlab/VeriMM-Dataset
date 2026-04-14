module top_module(SLEEP);input SLEEP; 
  always @(SLEEP) begin 
  if (SLEEP) begin 
  $write("%c[1;34m",27); 
  $display("***********************************************"); 
  $display("*********LAYER CONTROLLER IS POWER GATED*******"); 
  $display("*********AT TIME:", $time); 
  $display("***********************************************"); 
  $write("%c[0m",27); 
  end 
  else begin 
  $write("%c[1;34m",27); 
  $display("***********************************************"); 
  $display("********LAYER CONTROLLER IS POWER UNGATED******"); 
  $display("*********AT TIME:", $time); 
  $display("***********************************************"); 
  $write("%c[0m",27); 
  end 
  end 
 endmodule