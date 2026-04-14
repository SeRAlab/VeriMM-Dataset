module top_module(
  input [3:0] a,
  input [3:0] b,
  output reg [1:0] res
);always @(*) begin
    if (a > b) begin
      res = 2'b01;
    end else if (a < b) begin
      res = 2'b10;
    end else begin
      res = 2'b11;
    end
  end

endmodule