module top_module(
  input analog_in,
  output digital_out,
  input digital_in,
  output analog_out,
  input clk              // Added the clk input
);parameter OSR = 64;
parameter NUM_BITS = 16;
parameter MOD_ORDER = 1;
parameter SAMPLING_FREQ = 1000000;

reg [NUM_BITS-1:0] quantized_signal;
reg [NUM_BITS-1:0] feedback_signal;
reg [NUM_BITS-1:0] digital_out_reg;
reg [NUM_BITS-1:0] digital_in_reg;
reg [NUM_BITS-1:0] analog_out_reg;

always @(posedge clk) begin
  // Sigma-delta modulator
  feedback_signal <= analog_in - digital_out_reg;
  quantized_signal <= $signed(feedback_signal) >= 0 ? {NUM_BITS{1'b1}} : {NUM_BITS{1'b0}};
  digital_out_reg <= digital_out_reg + quantized_signal - feedback_signal/(OSR*MOD_ORDER);
  
  // Sigma-delta demodulator
  digital_in_reg <= digital_in;
  analog_out_reg <= $signed(digital_in_reg)/(OSR*MOD_ORDER);
end

assign digital_out = digital_out_reg;
assign analog_out = analog_out_reg;

endmodule