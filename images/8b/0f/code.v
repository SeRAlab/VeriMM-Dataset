module top_module(
  input [3:0] A,
  input [3:0] B,
  input C,
  output reg [3:0] S,
  output reg C_out
);always @(*) begin
    if (C) begin // subtraction
      S = A - B;
      C_out = (A < B) ? 1 : 0;
    end
    else begin // addition
      S = A + B;
      C_out = (S[4] == 1) ? 1 : 0;
    end
  end

endmodule