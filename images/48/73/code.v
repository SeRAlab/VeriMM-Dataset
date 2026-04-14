module top_module(
  in,
  out   );output reg out;
    input wire in ;

  always @(*)
begin
  out = ~in ;
  end

endmodule