module top_module(
  input in1,
  input in2,
  input in3,
  input in4,
  output reg out
);always @ (in1, in2, in3, in4) begin
    out = ((in1 & in2 & in3) | (in1 & in2 & in4) | (in1 & in3 & in4) | (in2 & in3 & in4));
  end
  
endmodule