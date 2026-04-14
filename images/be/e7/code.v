module top_module(
  input [7:0] a,
  input [7:0] b,
  input operation,
  output reg [8:0] result
);always @*
begin
  if(operation)
    result = a + b;
  else
    result = a - b;
end

endmodule