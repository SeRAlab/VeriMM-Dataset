module top_module(
  input [3:0] A,
  input [3:0] B,
  input [3:0] C,
  input [3:0] D,
  output reg match,
  output reg greater_than
);always @(*) begin
    if (A == B && C == D) begin
      match = 1;
    end
    else begin
      match = 0;
    end

    if ((A << 4 | C) > (B << 4 | D)) begin
      greater_than = 1;
    end
    else begin
      greater_than = 0;
    end
  end

endmodule