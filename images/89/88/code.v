module top_module(Q, clock, reset);output reg [3:0] Q;
  input clock, reset;
  
  always @(posedge clock)
  begin
    if(reset)
      Q <= 4'b1111;
    else
      Q <= { (Q[3] ^ Q[0]) , Q[3:1] };
  end
    
endmodule