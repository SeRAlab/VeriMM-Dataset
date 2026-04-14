module top_module(
  input [31:0] a, 
  input [31:0] b, 
  output reg [31:0] c
);reg [31:0] temp;
  reg [31:0] remainder;
  
  always @(*) begin
    temp = a / b;
    remainder = a - (temp * b);
    
    if (remainder >= b) begin
      remainder = remainder - b;
    end
    
    c = remainder;
  end
  
endmodule