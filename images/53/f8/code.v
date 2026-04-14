module top_module(
  input signed [31:0] a,
  input signed [31:0] b,
  output reg signed [31:0] result, // Change wire to reg for always block
  output error
);// Check if b is equal to 0
  assign error = (b == 0);

  // Compute the remainder
  always @(*) begin
    if (b != 0) begin
      result = a % b;
      if (result < 0) begin
        result = result + b;
      end
    end else begin
      result = 0; // Define result when b is 0 to avoid l-value issues
    end
  end

endmodule