module top_module(
  input clk,
  input pin,
  output reg conditioned,
  output reg rising,
  output reg falling
);reg pin_synced;
reg pin_cleaned;
reg [1:0] pin_preprocessed;

always @(posedge clk) begin
  // Synchronize the input signal with the system clock
  pin_synced <= pin;
  // Clean the input signal to remove any noise
  if (pin_synced == 1'b1) begin
    pin_cleaned <= 1'b1;
  end else if (pin_synced == 1'b0) begin
    pin_cleaned <= 1'b0;
  end
  // Preprocess the input signal to detect rising and falling edges
  pin_preprocessed <= {pin_preprocessed[0], pin_cleaned};
end

// Output the synchronized and cleaned input signal
assign conditioned = pin_cleaned;

// Output the rising and falling edge signals
always @(posedge clk) begin
  if (pin_preprocessed == 2'b01) begin
    rising <= 1'b1;
  end else begin
    rising <= 1'b0;
  end
  if (pin_preprocessed == 2'b10) begin
    falling <= 1'b1;
  end else begin
    falling <= 1'b0;
  end
end

endmodule