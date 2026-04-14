module top_module(
  input [15:0] x,
  output reg [31:0] ln_x,
  output reg [31:0] exp_x
);reg [31:0] ln_sum, exp_sum;
  reg [15:0] i;
  reg [31:0] x_pow_i, fact_i;

  always @(*) begin
    if (x == 0) begin
      ln_x = 0;
      exp_x = 1;
    end
    else if (x < 0) begin
      ln_x = -1;
      exp_x = 0;
    end
    else begin
      // Compute natural logarithm using Taylor series expansion
      ln_sum = 0;
      x_pow_i = x - 1;
      fact_i = 1;
      for (i = 1; i <= 10; i = i + 1) begin
        ln_sum = ln_sum + (x_pow_i / i) * fact_i;
        x_pow_i = x_pow_i * (x - 1);
        fact_i = fact_i * i;
      end
      ln_x = ln_sum;

      // Compute exponential function using Taylor series expansion
      exp_sum = 1;
      x_pow_i = 1;
      fact_i = 1;
      for (i = 1; i <= 10; i = i + 1) begin
        exp_sum = exp_sum + (x_pow_i / fact_i);
        x_pow_i = x_pow_i * x;
        fact_i = fact_i * i;
      end
      exp_x = exp_sum;
    end
  end

endmodule