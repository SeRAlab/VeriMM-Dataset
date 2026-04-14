module top_module(
  input signed [31:0] x,
  output reg signed [31:0] y1,  // Change to reg type
  output reg signed [31:0] y2   // Change to reg type
);reg [31:0] exp_result;
  reg [31:0] ln_result;
  integer i;

  always @(*) begin
    // Calculate e^x using Taylor series approximation
    exp_result = 32'h00000001; // Initialize with 1
    for (i = 1; i < 32; i = i + 1) begin
      exp_result = exp_result + (x ** i) / i;
    end

    // Calculate ln(x) using Taylor series approximation
    if (x > 0) begin
      ln_result = 0;
      for (i = 1; i < 32; i = i + 1) begin
        ln_result = ln_result + (((x - 1) ** i) / i) * (i % 2 == 1 ? 1 : -1);
      end
    end else begin
      ln_result = 32'h80000000; // Return the minimum 32-bit signed integer value for invalid input
    end

    // Assign the results to the output signals
    y1 = exp_result;
    y2 = ln_result;
  end

endmodule