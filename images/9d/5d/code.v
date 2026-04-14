module top_module(
  input [3:0] A,
  input [3:0] B,
  input enable,
  output reg [3:0] sum,
  output reg overflow
);always @(*) begin
  if(enable) begin
    sum = A + B;
    if(sum > 4'b1111) begin
      overflow = 1;
      sum = 4'b0000;
    end else begin
      overflow = 0;
    end
  end else begin
    sum = 4'b0000;
    overflow = 0;
  end
end

endmodule