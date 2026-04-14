module top_module(a, b, c);input signed [31:0] a;
  input signed [31:0] b;
  output signed [63:0] c;

  reg [31:0] a_tmp;
  reg [31:0] b_tmp;
  reg [63:0] c_tmp;
  reg is_neg_a;
  reg is_neg_b;

  always @(*) begin
    // Check if a is negative
    if (a[31] == 1) begin
      a_tmp = -a;
      is_neg_a = 1;
    end else begin
      a_tmp = a;
      is_neg_a = 0;
    end

    // Check if b is negative
    if (b[31] == 1) begin
      b_tmp = -b;
      is_neg_b = 1;
    end else begin
      b_tmp = b;
      is_neg_b = 0;
    end

    // Booth's algorithm multiplication
    c_tmp = {32'b0, a_tmp} * {32'b0, b_tmp};

    // If the signs of a and b are different, negate the result
    if (is_neg_a != is_neg_b) begin
      c_tmp = -c_tmp;
    end
  end

  assign c = c_tmp;
endmodule