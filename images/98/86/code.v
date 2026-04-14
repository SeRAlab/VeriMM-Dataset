module top_module( countClock, count, loadvalue, load, countout);input wire countClock; 
  input wire count; 
  input wire [7:0] loadvalue; 
  input wire load; 
  (* EQUIVALENT_REGISTER_REMOVAL="NO" *) output reg [7:0] countout; 
  always@(posedge countClock) 
  begin 
  if (load == 1'b1) countout <= loadvalue; 
  else countout <= countout - count; 
  end 
 endmodule