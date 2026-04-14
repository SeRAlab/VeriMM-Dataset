module top_module(
  input [7:0] A,
  input [7:0] B,
  output reg equal,
  output reg greater_than,
  output reg less_than
);always @(*) begin
    if (A == B) begin
      equal = 1;
      greater_than = 0;
      less_than = 0;
    end
    else if (A > B) begin
      equal = 0;
      greater_than = 1;
      less_than = 0;
    end
    else begin
      equal = 0;
      greater_than = 0;
      less_than = 1;
    end
  end
  
endmodule