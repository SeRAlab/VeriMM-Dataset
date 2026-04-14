module top_module(
  input clk,
  input sync,
  input reset,
  
  input [2:0]delay,
  input in,
  output out
);reg [7:0]shift;
  
  always @(posedge clk or posedge reset)
  begin
    if (reset) shift <= 0;
    else if (sync) shift <= { shift[6:0], in };
  end
  
  assign out = shift[delay];

endmodule