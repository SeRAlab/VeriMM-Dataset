module top_module(
  input [7:0] A,
  input [7:0] B,
  input operation,
  input reset,
  output reg [7:0] C
);integer result;

  always @(*) begin
    if (reset) begin
      C <= 8'b0;
    end else if (operation) begin
      result = A - B;
      C <= result;
    end else begin
      result = A + B;
      C <= result;
    end
  end

endmodule