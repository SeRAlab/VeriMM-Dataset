module top_module(
  input [n-1:0] in,
  input clk,
  output reg [m-1:0] out // changed 'output' to 'output reg'
);parameter n = 8; // number of input signals (data to be transmitted)
parameter m = 8; // number of output signals (received data)

reg [n+1:0] tx_data; // data to be transmitted
reg [n+1:0] rx_data; // received data
reg tx_busy; // flag indicating if transmitter is busy
reg rx_busy; // flag indicating if receiver is busy
reg tx_done; // flag indicating if transmission is complete
reg rx_done; // flag indicating if reception is complete
reg [1:0] tx_state; // state of transmitter
reg [1:0] rx_state; // state of receiver
reg [7:0] tx_count; // counter for transmitting data
reg [7:0] rx_count; // counter for receiving data

// IR transmitter
always @(posedge clk) begin
  case (tx_state)
    2'b00: begin // idle state
      if (!tx_busy) begin
        tx_data[0] <= 1'b0; // start bit
        tx_data[n+1] <= 1'b1; // stop bit
        tx_count <= 0;
        tx_state <= 2'b01; // go to transmit state
      end
    end
    2'b01: begin // transmit state
      if (tx_count < n + 2) begin
        out <= tx_data[tx_count]; // changed assignment from = to <=
        tx_count <= tx_count + 1;
      end else begin
        tx_busy <= 1'b0;
        tx_done <= 1'b1;
        tx_state <= 2'b00; // go back to idle state
      end
    end
  endcase
end

// IR receiver
always @(posedge clk) begin
  case (rx_state)
    2'b00: begin // idle state
      if (in == 1'b0) begin
        rx_count <= 0;
        rx_state <= 2'b01; // go to receive state
      end
    end
    2'b01: begin // receive state
      if (rx_count < n + 2) begin
        rx_data[rx_count] <= in; // changed assignment from = to <=
        rx_count <= rx_count + 1;
      end else begin
        rx_busy <= 1'b0;
        rx_done <= 1'b1;
        rx_state <= 2'b00; // go back to idle state
      end
    end
  endcase
end

// top-level module
always @(posedge clk) begin
  if (!tx_busy && !rx_busy) begin
    tx_busy <= 1'b1;
    tx_done <= 1'b0;
    tx_state <= 2'b00;
    rx_busy <= 1'b1;
    rx_done <= 1'b0;
    rx_state <= 2'b00;
  end
end

endmodule