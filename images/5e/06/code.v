module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  output reg [1:0] eq_gt
);parameter n = 4; // width of input signals

always @(*) begin
  if (A === B) begin // A is equal to B
    eq_gt = 2'b11;
  end else if (A > B) begin // A is greater than B
    eq_gt = 2'b10;
  end else if (A < B) begin // A is less than B
    eq_gt = 2'b01;
  end else if (A === {n{1'bx}} && B !== {n{1'bx}}) begin // A is X and B is not X
    eq_gt = 2'b01;
  end else if (A !== {n{1'bx}} && B === {n{1'bx}}) begin // A is not X and B is X
    eq_gt = 2'b10;
  end else begin // A and B are both X (unknown)
    eq_gt = 2'b10;
  end
end

endmodule