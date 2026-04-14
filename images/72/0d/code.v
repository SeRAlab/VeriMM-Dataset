module top_module(
  input signed [31:0] x,
  output reg signed [31:0] y  // Changed to reg to allow assignment in always blocks
);reg signed [31:0] arcsin;
  reg signed [31:0] arccos;
  reg signed [31:0] arctan;

  // Taylor series approximation for arcsin
  always @(*) begin
    arcsin = x + (x**3)/6 + (3*x**5)/40 + (5*x**7)/112;
  end

  // Taylor series approximation for arccos
  always @(*) begin
    arccos = (3.1415926/2) - arcsin;
  end

  // Taylor series approximation for arctan
  always @(*) begin
    arctan = x - (x**3)/3 + (x**5)/5 - (x**7)/7;
  end

  // Check the input range and set the output accordingly
  always @(*) begin
    if (x >= -1 && x <= 1) begin
      y = arcsin;
    end else if (x >= -1 && x <= 1) begin
      y = arccos;
    end else begin
      y = arctan;
    end
  end

endmodule