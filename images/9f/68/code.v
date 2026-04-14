module top_module(
  input clk,
  input reset,
  input [5:0] multiplicand,
  input [5:0] multiplier,
  output reg [10:0] product
);reg [5:0] shifted_multiplicand;
  reg [3:0] adder1_out;
  reg [3:0] adder2_out;
  reg [5:0] adder2_in;
  reg [5:0] adder2_in_shifted;
  reg [1:0] iteration_count;
  reg enable;

  always @(posedge clk) begin
    if (reset) begin
      shifted_multiplicand <= 0;
      adder1_out <= 0;
      adder2_out <= 0;
      adder2_in <= 0;
      adder2_in_shifted <= 0;
      iteration_count <= 0;
      enable <= 0;
      product <= 0;
    end else begin
      if (iteration_count == 0) begin
        shifted_multiplicand <= multiplicand;
        adder2_in <= multiplier;
        adder2_in_shifted <= {multiplier, 2'b0};
        enable <= 1;
      end else begin
        shifted_multiplicand <= {shifted_multiplicand[4:0], 1'b0};
        adder2_in <= adder2_out;
        adder2_in_shifted <= {adder2_out, 2'b0};
        enable <= 1;
      end

      if (enable) begin
        adder1_out <= shifted_multiplicand[0] ? adder2_in_shifted + multiplicand : adder2_in_shifted;
        adder2_out <= adder1_out[3:0] + adder1_out[7:4];
        product <= {adder2_out, adder1_out[2:0]};
        iteration_count <= iteration_count + 1;
        enable <= 0;
      end

      if (iteration_count == 6) begin
        iteration_count <= 0;
      end
    end
  end

endmodule