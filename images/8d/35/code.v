module top_module(
  input       clk,
  input [31:0] adc_input,
  output reg [31:0] dac_output, // Change to reg to allow assignment in always block
  output reg      dac_en        // Change to reg to allow assignment in always block
);always @(*) begin
    if (adc_input <= (2**31 - 1) / 2) begin
      dac_output = 0;
      dac_en = 0;
    end else begin
      dac_output = adc_input;
      dac_en = 1;
    end
  end

endmodule