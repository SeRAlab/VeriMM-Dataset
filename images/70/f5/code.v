module top_module(clock, reset,x,z,toggle,rise,fall);input clock,reset,x;
  output reg z,toggle,rise,fall;
  
  always@(posedge clock) begin
    if(reset) begin 
      z<=0;
    end
    else begin
      z<=x;
    end
  end

  assign toggle = z^x;
  assign rise = ~x&z;
  assign fall = x&~z;endmodule