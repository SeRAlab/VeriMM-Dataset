module top_module(clk,reset,quadA,quadB,count);input clk, reset, quadA, quadB; 
  output [7:0] count; 
  reg [2:0] quadA_delayed; 
  reg [2:0] quadB_delayed; 
  always @(posedge clk or posedge reset) begin 
  if (reset) begin 
  quadA_delayed <= 0; 
  end else begin 
  quadA_delayed <= {quadA_delayed[1:0], quadA}; 
  end 
  end 
  always @(posedge clk or posedge reset) begin 
  if (reset) begin 
  quadB_delayed <= 0; 
  end else begin 
  quadB_delayed <= {quadB_delayed[1:0], quadB}; 
  end 
  end 
  wire count_enable = quadA_delayed[1] ^ quadA_delayed[2] ^ quadB_delayed[1] ^ quadB_delayed[2]; 
  wire count_direction = quadA_delayed[1] ^ quadB_delayed[2]; 
  reg [31:0] total; 
  always @(posedge clk or posedge reset) begin 
  if (reset) begin 
  total <= 0; 
  end else if(count_enable) begin 
  if(count_direction) total <= total+1; 
  else total <= total-1; 
  end 
  end 
  wire [31:0] clicks; 
  assign clicks = total >> 2; 
  assign count = clicks[7:0]; 
 endmodule