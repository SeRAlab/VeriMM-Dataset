module top_module(
  input [7:0] a,
  input [7:0] b,
  input [7:0] c,
  output reg [7:0] y
);always @(*) begin
    if(a >= b && a >= c) begin
      y = a;
    end else if(b >= a && b >= c) begin
      y = b;
    end else begin
      y = c;
    end
  end

endmodule