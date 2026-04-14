module top_module(
  input signed [7:0] a,
  input signed [7:0] b,
  input op,
  input clk, // Added clk input
  output reg signed [7:0] result
);always @(*) begin
    if (op == 0) begin
      result = a + b;
    end else begin
      result = a - b;
    end
  end

  always @(posedge clk) begin
    // Check for overflow and underflow conditions
    if ((result[7] == 1 && op == 0 && a[7] == 1 && b[7] == 1) ||
        (result[7] == 1 && op == 1 && a[7] == 0 && b[7] == 1) ||
        (result[7] == 0 && op == 1 && a[7] == 1 && b[7] == 0)) begin
      // Overflow or underflow condition
      $display("Error: Overflow or underflow condition detected");
    end
  end

endmodule