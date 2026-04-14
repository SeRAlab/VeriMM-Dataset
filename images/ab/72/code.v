module top_module(
  input signed [31:0] a,
  input signed [31:0] b,
  output reg signed [31:0] result  // Change to reg
);wire signed [31:0] temp_result;

  assign temp_result = (b == 0) ? 0 : a % b;

  always @(*) begin
    if (a < 0 && b > 0) begin
      result = -temp_result;
    end else if (a > 0 && b < 0) begin
      result = -temp_result;
    end else begin
      result = temp_result;
    end
  end

endmodule