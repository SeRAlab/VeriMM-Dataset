module top_module(
  input [7:0] data_in,
  input [10:0] id_in,
  input tx_req,
  input clk,
  output reg tx,          // Changed to reg
  output reg tx_ack,      // Changed to reg
  input rx,
  output reg [10:0] id_out, // Changed to reg
  output reg [7:0] data_out  // Changed to reg
);// Define CAN protocol and message format
  parameter CAN_BITRATE = 125000; // 125 kbps
  parameter CAN_MSG_SIZE = 11; // 11-bit identifier
  parameter CAN_DATA_SIZE = 8; // 8-bit data

  // Define internal signals
  reg [CAN_MSG_SIZE-1:0] tx_id;
  reg [CAN_DATA_SIZE-1:0] tx_data;
  reg tx_valid;
  reg tx_busy;
  reg [CAN_MSG_SIZE-1:0] rx_id;
  reg [CAN_DATA_SIZE-1:0] rx_data;
  reg rx_valid;

  // Define transmitter block
  always @(posedge clk) begin
    if (tx_req && !tx_busy) begin
      tx_id <= id_in;
      tx_data <= data_in;
      tx_valid <= 1;
      tx_busy <= 1;
    end else if (tx_valid) begin
      tx <= 1;
      tx_ack <= 0;
      tx_valid <= 0;
      tx_busy <= 0;
    end else begin
      tx <= 0;
      tx_ack <= 1;
    end
  end

  // Define receiver block
  always @(posedge clk) begin
    if (rx) begin
      rx_id <= id_out;
      rx_data <= data_out;
      rx_valid <= 1;
    end else begin
      rx_valid <= 0;
    end
  end

  // Connect inputs and outputs to transmitter and receiver blocks
  always @(posedge clk) begin
    id_out <= rx_id;        // Assigning to reg
    data_out <= rx_data;    // Assigning to reg
  end

endmodule