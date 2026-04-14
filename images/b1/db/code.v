module top_module(
  input [3:0] A,
  input [3:0] B,
  input M,
  input CLK,
  input RST,
  output reg [3:0] S,
  output reg C
);always @(posedge CLK) begin
    if (RST) begin
      S <= 4'b0;
      C <= 1'b0;
    end else begin
      if (M) begin // subtraction
        S <= A - B;
        C <= (A < B) ? 1'b1 : 1'b0;
      end else begin // addition
        S <= A + B;
        C <= (S < A) ? 1'b1 : 1'b0;
      end
    end
  end

endmodule