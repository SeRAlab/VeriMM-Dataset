module top_module( clk, reset, init, d, q );input clk; 
  input reset; 
  input [8:0] init; 
  input [8:0] d; 
  output [8:0] q; 
  reg [8:0] q; 
 `ifdef RANDOM_INIT 
  initial 
  $random_init("q"); 
 `endif 
 `ifdef CHK_RESET_EOS 
 assert_quiescent_state #(0,1,0,"***ERROR ASSERT: reset still asserted at end of simulation") 
 a0(.clk(clk),.reset_n(1'b1), .state_expr(reset),.check_value(1'b0), .sample_event(1'b0)); 
 `endif 
  always @(posedge clk) begin 
  if (reset) 
  q <= init; 
  else 
  q <= d; 
  end 
 endmodule