module top_module(
  input [3:0] X,
  input [3:0] Y,
  output reg [3:0] result,
  output reg greater_than_or_equal_to_5
);always @* begin
    result = X & Y;
    
    if (result >= 5) begin
      greater_than_or_equal_to_5 = 1;
    end else begin
      greater_than_or_equal_to_5 = 0;
    end
  end
  
endmodule