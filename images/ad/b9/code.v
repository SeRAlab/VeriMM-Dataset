module top_module(count,start);input start; 
  output reg [31:0] count; initial count = 0; 
  reg [31:0] runnerm1, runner; initial runner = 0; 
  always @ (posedge start) begin 
  runner = 3; 
  end 
  always @ (runner) begin 
  runnerm1 = runner - 32'd1; 
  end 
  always @ (runnerm1) begin 
  if (runner > 0) begin 
  count = count + 1; 
  runner = runnerm1; 
  $write ("%m count=%d runner =%x\n",count, runnerm1); 
  end 
  end 
 endmodule