module top_module(
  input [3:0] a,
  input [3:0] b,
  output reg [4:0] sum
);always @(*) begin
  case ({a, b})
    8'b0000, 8'b0001, 8'b0010, 8'b0100, 8'b1000: sum = 4'b0;
    8'b0011, 8'b0101, 8'b1001, 8'b1010, 8'b1100: sum = 5'b10;
    default: sum = a + b;
  endcase
end

endmodule