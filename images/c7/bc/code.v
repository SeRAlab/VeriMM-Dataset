module addition (
  input [7:0] a,
  input [7:0] b,
  output reg [8:0] result
);

always @(*) begin
  result = {1'b0, a} + {1'b0, b};
end

endmodule