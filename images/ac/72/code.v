module top_module(
  input [31:0] A,
  input [31:0] B,
  input [31:0] C,
  output reg [31:0] X
);always @(*) begin
    if (A > B) begin
      if (A > C) begin
        X = A;
      end else begin
        X = C;
      end
    end else begin
      if (B > C) begin
        X = B;
      end else begin
        X = C;
      end
    end
  end

endmodule