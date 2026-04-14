module top_module(
  input clk,
  input reset,
  input signed [3:0] A,
  input signed [3:0] B,
  output reg signed [7:0] product
);reg signed [3:0] A_shifted;
  reg signed [3:0] B_shifted;
  reg signed [7:0] product_reg;

  always @(posedge clk) begin
    if (reset) begin
      A_shifted <= 0;
      B_shifted <= 0;
      product_reg <= 0;
      product <= 0;
    end else begin
      A_shifted <= {A, 1'b0};
      B_shifted <= {1'b0, B[3:1]};
      if (B[0]) begin
        product_reg <= product_reg + A_shifted;
      end
      A_shifted <= A_shifted << 1;
      B_shifted <= B_shifted >> 1;
      if (B[1]) begin
        product_reg <= product_reg + A_shifted;
      end
      A_shifted <= A_shifted << 1;
      B_shifted <= B_shifted >> 1;
      if (B[2]) begin
        product_reg <= product_reg + A_shifted;
      end
      A_shifted <= A_shifted << 1;
      B_shifted <= B_shifted >> 1;
      if (B[3]) begin
        product_reg <= product_reg + A_shifted;
      end
      product <= product_reg;
    end
  end

endmodule