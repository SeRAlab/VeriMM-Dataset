module top_module(
  input clk,
  input rst,
  input [7:0] data_in,  // Changed to 8-bit input
  input valid_in,
  output reg [7:0] data_out,  // Changed to reg type
  output reg valid_out        // Changed to reg type
);// Define internal signals
  reg [7:0] tx_data;
  reg [7:0] rx_data;
  reg tx_valid;
  reg rx_valid;

  // Transmitter block
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      tx_data <= 8'b0;
      tx_valid <= 1'b0;
    end else if (valid_in) begin
      tx_data <= data_in;
      tx_valid <= 1'b1;
    end else if (tx_valid) begin
      tx_data <= 8'b0;
      tx_valid <= 1'b0;
    end
  end

  // Receiver block
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      rx_data <= 8'b0;
      rx_valid <= 1'b0;
      valid_out <= 1'b0;  // Initialize valid_out on reset
    end else if (rx_valid) begin
      data_out <= rx_data;
      valid_out <= 1'b1;
      rx_valid <= 1'b0;
    end else begin
      valid_out <= 1'b0;  // Reset valid_out if not valid
    end
  end

  // Assume these are coming from the Bluetooth hardware
  // These should be defined as inputs
  wire [7:0] bluetooth_tx_data;   // Sample declared wire
  wire bluetooth_tx_valid;         // Sample declared wire
  wire [7:0] bluetooth_rx_data;    // Sample for demonstration
  wire bluetooth_rx_valid;          // Sample for demonstration

  // Connect to Bluetooth hardware
  always @(posedge clk) begin
    if (tx_valid) begin
      // Assign tx_data and tx_valid to your Bluetooth transmission module 
      // Logic to send tx_data and tx_valid would be implemented here
    end
  end

  always @(posedge clk) begin
    if (bluetooth_rx_valid) begin
      rx_data <= bluetooth_rx_data;  // Store incoming data
      rx_valid <= 1'b1;               // Mark the data as valid
    end
  end

endmodule