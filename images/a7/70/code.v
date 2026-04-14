module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  output eq,
  output gt,
  output lt
);parameter n = 8; // number of bits in A and B

reg unsigned_eq, unsigned_gt, unsigned_lt; // signals for unsigned comparison
reg signed_eq, signed_gt, signed_lt; // signals for signed comparison

// unsigned comparison
always @(*) begin
  unsigned_eq = (A == B);
  unsigned_gt = (A > B);
  unsigned_lt = (A < B);
end

// signed comparison
always @(*) begin
  if (A[n-1] == 0 && B[n-1] == 1) begin // A is positive, B is negative
    signed_eq = 0;
    signed_gt = 1;
    signed_lt = 0;
  end else if (A[n-1] == 1 && B[n-1] == 0) begin // A is negative, B is positive
    signed_eq = 0;
    signed_gt = 0;
    signed_lt = 1;
  end else begin // A and B have the same sign
    unsigned_eq = ({1'b0, A[n-2:0]} == {1'b0, B[n-2:0]});
    unsigned_gt = (A[n-1] == 0 && B[n-1] == 1 && !signed_eq) || (unsigned_gt && !signed_eq);
    unsigned_lt = (A[n-1] == 1 && B[n-1] == 0 && !signed_eq) || (unsigned_lt && !signed_eq);
  end
end

// output signals
assign eq = unsigned_eq || signed_eq;
assign gt = unsigned_gt || signed_gt;
assign lt = unsigned_lt || signed_lt;

endmodule