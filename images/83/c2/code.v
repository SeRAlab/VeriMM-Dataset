module top_module(
  input [3:0] a,
  input [3:0] b,
  output reg [7:0] y,
  output reg error
);always @(*) begin
    y = (a + b) * (a + b);
    if (y != (a + b) << 8) begin
      error = 1;
    end else begin
      error = 0;
    end
  end
  
endmodule