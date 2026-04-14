module top_module(rnum, nr_wait_cycle);input [31:0] rnum; 
 output reg [7:0] nr_wait_cycle; 
 always @(rnum) begin :body 
  reg [7:0] n; 
  n = rnum[7:0]; 
  if (n >= 64) begin 
  nr_wait_cycle = 0; 
  end else if (n >= 32) begin 
  nr_wait_cycle = 1; 
  end else if (n >= 16) begin 
  nr_wait_cycle = 2; 
  end else if (n >= 8) begin 
  nr_wait_cycle = 3; 
  end else if (n >= 4) begin 
  nr_wait_cycle = 4; 
  end else if (n >= 2) begin 
  nr_wait_cycle = 5; 
  end else if (n >= 1) begin 
  nr_wait_cycle = 6; 
  end else begin 
  nr_wait_cycle = rnum[15:8]; 
  end 
 end 
 endmodule