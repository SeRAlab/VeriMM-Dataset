module top_module(
  input [3:0] A,
  input [3:0] B,
  input Sub,
  output reg [3:0] Sum,
  output reg Borrow
);always @(*) begin
  if(Sub == 0) begin // Addition
    Sum = A + B;
    Borrow = 0;
  end else begin // Subtraction
    Sum = A - B;
    if(A < B) begin
      Borrow = 1;
    end else begin
      Borrow = 0;
    end
  end
end

endmodule