module top_module(
  input  clk,
  input  rst_n,

  output [4:0] data
);reg [4:0] state;

always @(posedge clk or negedge rst_n)
  if (~rst_n) 
    state <= 5'b11111;
  else
    state <= {state[3:0], state[4] ^ state[1]} ;

assign data = state;

endmodule