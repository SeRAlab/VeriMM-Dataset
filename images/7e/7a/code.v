module top_module(
  input signed [31:0] in,
  output reg [31:0] out
);// input is a 32-bit signed binary number
  // output is a 32-bit unsigned binary number
  
  always @(*) begin
    if (in < 0) begin
      out <= ~in + 1;
    end
    else begin
      out <= in;
    end
  end
  
endmodule