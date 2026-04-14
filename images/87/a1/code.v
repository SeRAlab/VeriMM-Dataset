module top_module(
  input angle,
  output sin,
  output cos,
  output tan
);reg [31:0] numerator_sine, numerator_cosine, denominator;
  reg [31:0] x_squared, x_cubed, x_fifth, x_seventh;
  reg [31:0] sine, cosine, tangent;
  
  assign sin = sine;
  assign cos = cosine;
  assign tan = tangent;
  
  always @(*) begin
    x_squared = angle * angle;
    x_cubed = angle * x_squared;
    x_fifth = x_cubed * x_squared;
    x_seventh = x_fifth * x_squared;
    
    numerator_sine = angle - x_cubed/6 + x_fifth/120 - x_seventh/5040;
    numerator_cosine = 1 - x_squared/2 + x_fifth/24 - x_seventh/720;
    denominator = numerator_cosine;
    
    sine = numerator_sine;
    cosine = numerator_cosine;
    tangent = sine / cosine;
  end
  
endmodule