module top_module (
  input [3:0] a,
  input [3:0] b,
  output reg greater);

always @(*) begin
    if (a > b)
        greater = 1;
    else
        greater = 0;
end
endmodule