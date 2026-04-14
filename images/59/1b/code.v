module top_module(
  input clk,
  input signed [15:0] data_in_a,
  input signed [15:0] data_in_b,
  input enable,
  output signed [31:0] result
);wire [31:0] mult_result;
  wire [31:0] sign_ext_result;
  reg signed [31:0] accum_result;

  // Perform signed multiplication of input data
  assign mult_result = data_in_a * data_in_b;

  // Sign-extend the multiplication result to 32 bits
  assign sign_ext_result = {{16{mult_result[15]}}, mult_result[15:0]};

  // Update the accumulator result on the rising edge of the clock if enable is high
  always @(posedge clk) begin
    if (enable) begin
      accum_result <= accum_result + sign_ext_result;
    end
  end

  // Assign the accumulator result to the output
  assign result = accum_result;

endmodule