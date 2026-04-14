module top_module(
  input [7:0] a,
  input [7:0] b,
  input [7:0] c,
  input [7:0] d,
  output reg [7:0] min_val
);always @(*) begin
    if(a < b && a < c && a < d) begin
      min_val = a;
    end
    else if(b < a && b < c && b < d) begin
      min_val = b;
    end
    else if(c < a && c < b && c < d) begin
      min_val = c;
    end
    else begin
      min_val = d;
    end
  end
  
endmodule